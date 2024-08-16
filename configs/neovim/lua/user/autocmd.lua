vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function () vim.highlight.on_yank({ timeout = 100 --[[ms]] }) end,
    desc     = 'Briefly highlight yanked text',
})

vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function () vim.diagnostic.setqflist({ open = false }) end,
    desc     = 'Keep the quickflix list up to date'
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
    desc    = 'Disable line numbers and enter terminal mode',
})
