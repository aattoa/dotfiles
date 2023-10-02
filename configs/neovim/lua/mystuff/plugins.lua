-- https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- Fuzzy file navigation
    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }

    -- Advanced syntax highlighting
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

    -- Easy comment/uncomment
    use {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    }

    -- Language server protocol
    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { 'L3MON4D3/LuaSnip' },
        }
    }

    -- Overload navigation
    use "Issafalcon/lsp-overloads.nvim"

    -- Display LSP diagnostics in a separate pane
    use {
        "folke/trouble.nvim",
        requires = { { "nvim-tree/nvim-web-devicons" } }
    }

    -- Personal wiki
    use "vimwiki/vimwiki"

    -- Preview colors in source code
    use "ap/vim-css-color"

    -- Colorscheme
    use "tiagovla/tokyodark.nvim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
