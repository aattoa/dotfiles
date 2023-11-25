return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        {
            "saadparwaiz1/cmp_luasnip",
            dependencies = { "L3MON4D3/LuaSnip" },
        },
    },
    config = function ()
        local cmp = require("cmp")
        cmp.setup {
            sources = {
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "nvim_lua" },
                { name = "buffer" },
                { name = "path" },
            },
            mapping = cmp.mapping.preset.insert {
                ["<Tab>"]    = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<S-Tab>"]  = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<Return>"] = cmp.mapping.confirm({ select = false }),
                ["<C-j>"]    = cmp.mapping.scroll_docs(1),
                ["<C-k>"]    = cmp.mapping.scroll_docs(-1),
                ["<C-c>"]    = cmp.mapping.abort(),
            },
            snippet = {
                expand = function (args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                completion    = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            preselect = cmp.PreselectMode.None,
        }
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
            }
        })
    end,
    event = { "InsertEnter", "CmdlineEnter" },
}
