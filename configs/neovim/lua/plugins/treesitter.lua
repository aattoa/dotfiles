local textobject_keys = {
    f = "function",
    a = "parameter",
    i = "call",
    l = "loop",
    r = "return",
    c = "conditional",
}

local textobjects = {
    select = {
        enable    = true,
        lookahead = true,
        keymaps   = {},
    },
    move = {
        enable              = true,
        set_jumps           = false,
        goto_next_start     = {},
        goto_next_end       = {},
        goto_previous_start = {},
        goto_previous_end   = {},
    },
    swap = {
        enable        = true,
        swap_next     = { ["<Leader>>"] = "@parameter.inner" },
        swap_previous = { ["<Leader><"] = "@parameter.inner" },
    },
}

-- Create consistent mappings
for key, name in pairs(textobject_keys) do
    local outer = "@" .. name .. ".outer"
    local inner = "@" .. name .. ".inner"

    textobjects.select.keymaps["a" .. key] = outer
    textobjects.select.keymaps["i" .. key] = inner

    textobjects.move.goto_previous_start["[" .. key:lower()] = outer
    textobjects.move.goto_previous_end  ["[" .. key:upper()] = outer
    textobjects.move.goto_next_start    ["]" .. key:lower()] = outer
    textobjects.move.goto_next_end      ["]" .. key:upper()] = outer
end

local highlight = {
    enable                            = true,
    additional_vim_regex_highlighting = false,
}

local incremental_selection = {
    enable  = true,
    keymaps = {
        init_selection   = "+",
        node_incremental = "+",
        node_decremental = "-",
    },
}

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function ()
        require("nvim-treesitter.configs").setup({
            ensure_installed      = { "cpp", "rust", "lua" }, -- Use :TSInstall all
            sync_install          = false,
            auto_install          = false,
            textobjects           = textobjects,
            highlight             = highlight,
            incremental_selection = incremental_selection,
        })

        -- Fold with treesitter
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

        -- Repeat textobject motions
        vim.keymap.set({ "n", "x" }, "[[", "<Cmd>TSTextobjectRepeatLastMovePrevious<CR>zz")
        vim.keymap.set({ "n", "x" }, "]]", "<Cmd>TSTextobjectRepeatLastMoveNext<CR>zz")

        -- Make it easier to hold down `[[` and `]]`
        vim.keymap.set({ "n", "x" }, "[]", "<Nop>")
        vim.keymap.set({ "n", "x" }, "][", "<Nop>")

        -- Highlight C++ modifiers (const, thread_local, etc.) like built in types
        vim.api.nvim_set_hl(0, "@keyword.modifier.cpp", { link = "@type.builtin" })
    end,
    event = "VeryLazy",
}
