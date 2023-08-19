-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 100 }) end,
})

-- Automatically update plugins when plugins.lua is updated
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])
