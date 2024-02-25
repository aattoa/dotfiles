return {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function ()
        require("nvim-treesitter.configs").setup {
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "cpp", "haskell", "python", "rust", "ocaml", "bash", "make", "cmake", "diff", "git_config", "gitcommit", "gitignore", "json", "markdown", "markdown_inline", "sql", "toml", "yaml" },
            sync_install     = false,
            auto_install     = true, -- Set to false if tree-sitter CLI is not installed locally
            highlight        = { enable = true, additional_vim_regex_highlighting = false },
            textobjects      = {
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
            },
        }
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    event = "VeryLazy",
}
