vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function () vim.highlight.on_yank({ timeout = 100 --[[ms]] }) end,
    desc     = 'Briefly highlight yanked text',
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    pattern  = 'make',
    callback = function (event)
        local ns = vim.api.nvim_create_namespace('my-quickfix-list-diagnostics')
        vim.diagnostic.set(ns, event.buf, vim.diagnostic.fromqflist(vim.fn.getqflist()))
    end,
    desc = 'Convert quickfix list to diagnostics',
})

vim.api.nvim_create_autocmd({ 'WinNew', 'VimEnter' }, {
    command = [[call matchadd('Todo', '\ctodo\|\cfixme\|\cnocommit')]],
    desc    = 'Define highlight matches for special text markers',
})

vim.api.nvim_create_autocmd('TermOpen', {
    command = 'setlocal nonumber norelativenumber | startinsert',
    desc    = 'Disable line numbers and start in terminal mode',
})

vim.api.nvim_create_autocmd('VimEnter', {
    callback = function ()
        vim.api.nvim_del_augroup_by_name('Network')
    end,
    once = true,
    desc = 'Remove unnecessary autocommands',
})

if vim.o.cursorline then
    vim.api.nvim_create_autocmd('WinEnter', {
        command = 'setlocal cursorline',
        desc    = 'Enable cursorline for the active window',
    })
    vim.api.nvim_create_autocmd('WinLeave', {
        command = 'setlocal nocursorline',
        desc    = 'Disable cursorline for inactive windows',
    })
end
