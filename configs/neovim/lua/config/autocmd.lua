vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function () vim.highlight.on_yank({ timeout = 100 --[[milliseconds]] }) end,
    desc     = "Briefly highlight yanked text",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern  = "markdown",
    callback = function () vim.bo.makeprg = "pandoc % -o %<.pdf &" end,
    desc     = "Make markdown files by converting them to PDF",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern  = { "help", "man" },
    callback = function ()
        vim.wo.scrolloff  = 999 -- Keep the cursor centered
        vim.wo.cursorline = false
        vim.keymap.set("n", "J", "3j", { buffer = true })
        vim.keymap.set("n", "K", "3k", { buffer = true })
    end,
    desc = "Set local options and key mappings for documentation buffers",
})
