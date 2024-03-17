-- https://github.com/folke/lazy.nvim#-installation

---@type string
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone the plugin manager if it is not present.
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Latest stable release.
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
    ui = {
        border = "double",
    },
    defaults = {
        lazy = true,
    },
    change_detection = {
        notify = false,
    },
})

vim.keymap.set("n", "<Leader>p", vim.cmd.Lazy)
