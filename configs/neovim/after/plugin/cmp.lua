local cmp = require("cmp")

cmp.setup {
     sources = {
         { name = "nvim_lua" },
         { name = "nvim_lsp" },
         { name = "buffer" },
         { name = "path" },
     },
     mapping = cmp.mapping.preset.insert {
         ["<Tab>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
         ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
         ["<C-j>"]   = cmp.mapping.scroll_docs(1),
         ["<C-k>"]   = cmp.mapping.scroll_docs(-1),
     },
     preselect = cmp.PreselectMode.None,
}

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } }
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "cmdline" },
        { name = "path"  },
        { name = "buffer" },
    }
})
