return {
    "tiagovla/tokyodark.nvim",
    lazy     = false,
    priority = 1000, -- Load this before any other plugin
    config   = function () vim.cmd.colorscheme("tokyodark") end,
}
