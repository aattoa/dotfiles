vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 100 --[[milliseconds]] }) end,
    desc     = "Briefly highlight yanked text",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern  = "markdown",
    callback = function () vim.bo.makeprg = "pandoc % -o %<.pdf &" end,
    desc     = "Make markdown files by converting them to PDF",
})
