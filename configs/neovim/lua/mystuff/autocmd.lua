vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 100 --[[milliseconds]] }) end,
    desc     = "Briefly highlight yanked text"
})

local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", {})
vim.api.nvim_create_autocmd("BufWritePost", {
    group   = packer_user_config,
    pattern = vim.fn.expand("$MY_DOTFILES_REPO") .. "/configs/neovim/lua/mystuff/plugins.lua",
    command = "source <afile> | PackerSync",
    desc    = "Automatically update plugins when plugins.lua is updated",
})
