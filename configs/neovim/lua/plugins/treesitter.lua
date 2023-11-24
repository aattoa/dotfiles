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
                    },
                    enable                         = true,
                    lookahead                      = true,
                    include_surrounding_whitespace = false,
                }
            }
        }
    end,
    event = "VeryLazy",
}
