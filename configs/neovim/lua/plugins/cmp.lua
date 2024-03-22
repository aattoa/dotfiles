return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function ()
        local cmp = require("cmp")
        cmp.setup({
            sources = {
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "path" },
                { name = "buffer" },
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"]    = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<S-Tab>"]  = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<Return>"] = cmp.mapping.confirm({ select = false }),
                ["<C-l>"]    = cmp.mapping.complete({ config = { sources = {{ name = "nvim_lsp" }} } }),
                ["<C-j>"]    = cmp.mapping.scroll_docs(1),
                ["<C-k>"]    = cmp.mapping.scroll_docs(-1),
                ["<C-c>"]    = cmp.mapping.abort(),
            }),
            snippet = {
                expand = function (args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                completion    = cmp.config.window.bordered({ scrolloff = 2 }),
                documentation = cmp.config.window.bordered(),
            },
            preselect = cmp.PreselectMode.None,
        })
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{ name = "buffer" }}
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "cmdline" },
                { name = "path"  },
                { name = "buffer" },
            },
        })
    end,
    event = { "InsertEnter", "CmdlineEnter" },
}
