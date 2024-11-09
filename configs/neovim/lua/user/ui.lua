---@diagnostic disable-next-line: duplicate-set-field
function vim.ui.input(opts, on_confirm)
    local buffer = vim.api.nvim_create_buf(false --[[listed]], true --[[scratch]])
    local window = vim.api.nvim_open_win(buffer, true --[[enter]], {
        border = vim.g.floatborder,
        width = vim.o.columns, -- Overridden below
        height = 1,
        row = 1,
        col = 0,
        relative = 'cursor',
    })
    vim.cmd('setlocal buftype=prompt bufhidden=wipe sidescrolloff=0 nonumber norelativenumber')

    vim.fn.prompt_setprompt(buffer, opts.prompt or '')
    vim.fn.prompt_setcallback(buffer, function (result)
        on_confirm(result)
        vim.api.nvim_win_close(window, true --[[force]])
        vim.cmd.stopinsert()
    end)
    vim.api.nvim_set_current_line((opts.prompt or '') .. (opts.default or ''))

    vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
        callback = function ()
            vim.api.nvim_win_set_width(window, #vim.api.nvim_get_current_line() + 2)
        end,
        buffer = buffer,
        desc = 'Keep the input window appropriately sized',
    })
    vim.keymap.set('n', '<esc>', '<cmd>close!<cr>', { buffer = buffer })
    vim.cmd.startinsert({ bang = true })
end

local select_ns = vim.api.nvim_create_namespace('my-ui-select-highlighting')
vim.api.nvim_set_hl(select_ns, 'CursorLine', { bold = true, standout = true })

---@diagnostic disable-next-line: duplicate-set-field
function vim.ui.select(items, opts, on_choice)
    local lines = vim.tbl_map(opts.format_item or tostring, items)
    local buffer, window = vim.lsp.util.open_floating_preview(lines, '', {})
    vim.wo[window].cursorline = true
    vim.api.nvim_win_set_hl_ns(window, select_ns)
    vim.api.nvim_set_current_win(window)

    local function accept()
        local idx = vim.fn.line('.')
        vim.api.nvim_win_close(window, true)
        on_choice(items[idx], idx)
    end
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buffer })
    vim.keymap.set('n', '<esc>', '<cmd>close<cr>', { buffer = buffer })
    vim.keymap.set('n', '<cr>', accept, { buffer = buffer })
end
