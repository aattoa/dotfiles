-- https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd.packadd("packer.nvim")
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function (use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- Depended on by many other plugins
    use "nvim-lua/plenary.nvim"

    -- Fuzzy file navigation
    use "nvim-telescope/telescope.nvim"

    -- Advanced syntax highlighting
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }

    -- Syntax aware text objects
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after    = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    }

    -- Easy comment/uncomment
    use {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end,
    }

    -- Language server protocol
    use "neovim/nvim-lspconfig"
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"

    -- Autocompletion
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"

    -- Display LSP diagnostics in a separate pane
    use "folke/trouble.nvim"

    -- Overload navigation
    use "Issafalcon/lsp-overloads.nvim"

    -- Personal wiki
    use "vimwiki/vimwiki"

    -- Preview colors in source code
    use "ap/vim-css-color"

    -- Colorscheme
    use "tiagovla/tokyodark.nvim"

    -- Automatically sync plugins if this is the first run
    if packer_bootstrap then require("packer").sync() end
end)
