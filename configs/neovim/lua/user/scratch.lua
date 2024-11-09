local M = {}

---@type fun(fullscreen?: boolean, scale?: number): vim.api.keyset.win_config
function M.window_config(fullscreen, scale)
    scale = fullscreen and 1 or scale or 0.75
    local width = vim.o.columns
    local height = vim.o.lines - (vim.o.cmdheight + 3)
    return {
        relative = 'editor',
        width    = math.floor(width  * scale),
        height   = math.floor(height * scale),
        col      = math.floor(width  * (1 - scale) / 2),
        row      = math.floor(height * (1 - scale) / 2),
        border   = vim.g.floatborder,
    }
end

---@param command? string[]|string
function M.terminal(command)
    local scale = 0.75
    local fullscreen = false
    local scratchcmd = vim.b.scratchcmd
    local buffer = vim.api.nvim_create_buf(false --[[listed]], false --[[scratch]])
    local window = vim.api.nvim_open_win(buffer, true --[[enter]], M.window_config(fullscreen, scale))

    local function map(keys, callback)
        vim.keymap.set('n', keys, function ()
            callback()
            vim.api.nvim_win_set_config(window, M.window_config(fullscreen, scale))
        end, { buffer = buffer })
    end
    map('<c-f>', function () fullscreen = not fullscreen end)
    map('<', function () scale = math.max(scale - 0.025, 0.1) end)
    map('>', function () scale = math.min(scale + 0.025, 1) end)

    vim.api.nvim_buf_call(buffer, function ()
        vim.fn.termopen(command or scratchcmd or vim.o.shell)
    end)
end

-- A floating terminal for quick operations
vim.keymap.set('n', '<leader><cr>', M.terminal)

-- Run arbitrary shell commands
vim.api.nvim_create_user_command('Scratch', function (args)
    M.terminal(args.args)
end, { nargs = 1, complete = 'shellcmd' })

return M
