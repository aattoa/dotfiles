---@type table
local textobjects = {
    select = {
        keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ai"] = "@call.outer",
            ["ii"] = "@call.inner",
            ["ar"] = "@return.outer",
            ["ir"] = "@return.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
        },
        enable                         = true,
        lookahead                      = true,
        include_surrounding_whitespace = false,
    },
}

---@type table
local highlight = {
    enable                            = true,
    additional_vim_regex_highlighting = false,
}

return {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function ()
        require("nvim-treesitter.configs").setup({
            ensure_installed = "all",
            sync_install     = false,
            textobjects      = textobjects,
            highlight        = highlight,
        })
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    event = "VeryLazy",
}
