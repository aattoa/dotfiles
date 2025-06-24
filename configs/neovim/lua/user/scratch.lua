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
        border   = vim.g.winborder,
    }
end

---@class ScratchTerminalConfig
---@field quick? boolean Immediately close the terminal when the process exits.
---@field scale? number Window scale 0.0 - 1.0

---@param command string[]|string
---@param config? ScratchTerminalConfig
function M.terminal(command, config)
    if not command then
        vim.notify('Scratch terminal: No command given', vim.log.levels.ERROR)
        return
    end

    local fullscreen = false
    local scale = config and config.scale or 0.75
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
        vim.fn.jobstart(command, {
            on_exit = function ()
                if config and config.quick then
                    vim.api.nvim_buf_delete(buffer, {})
                end
            end,
            term = true,
        })
    end)
end

-- Floating terminal for buffer-local scratch commands
vim.keymap.set('n', '<leader><cr>', function () M.terminal(vim.b.scratchcmd or { 'run-tests' }) end)

-- Floating terminal for quick operations
vim.keymap.set('n', '<leader><c-t>', function () M.terminal(vim.o.shell) end)

-- Run arbitrary shell commands
vim.api.nvim_create_user_command('Scratch', function (args)
    M.terminal(args.args)
end, { nargs = 1, complete = 'shellcmd' })

return M
