-- https://github.com/folke/lazy.nvim

---@type string
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone the plugin manager if it is not present.
if not vim.loop.fs_stat(lazypath) then ---@diagnostic disable-line: undefined-field
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
        icons = { -- No need for a patched font.
            list    = { "-" },
            cmd     = "[CMD]",
            config  = "[CONF]",
            event   = "[EV]",
            ft      = "[FT]",
            init    = "[INIT]",
            keys    = "[KB]",
            plugin  = "[PLUG]",
            runtime = "[RT]",
            require = "[REQ]",
            source  = "[SRC]",
            start   = "[START]",
            task    = "[TASK]",
            lazy    = "[LAZY]",
        },
        border = "rounded",
    },
    performance = {
        rtp = {
            disabled_plugins = { -- Unnecessary built-in plugins.
                "editorconfig",
                "gzip",
                "osc52",
                "spellfile",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    change_detection = { enabled = false },
    defaults = { lazy = true },
})

vim.keymap.set("n", "<Leader>p", "<Cmd>Lazy<CR>")
