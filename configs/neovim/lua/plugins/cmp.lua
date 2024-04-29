return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function ()
        local cmp = require("cmp")
        cmp.setup({
            sources = {
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<CR>"]    = cmp.mapping.confirm({ select = false }),
                ["<C-l>"]   = cmp.mapping.complete({ config = { sources = {{ name = "nvim_lsp" }} } }),
                ["<C-j>"]   = cmp.mapping.scroll_docs(1),
                ["<C-k>"]   = cmp.mapping.scroll_docs(-1),
                ["<C-c>"]   = cmp.mapping.abort(),
            }),
            snippet = {
                expand = function (args)
                    vim.snippet.expand(args.body)
                end,
            },
            window = {
                completion    = cmp.config.window.bordered({ scrolloff = 2 }),
                documentation = cmp.config.window.bordered(),
            },
            preselect = cmp.PreselectMode.None,
        })
    end,
    event = { "InsertEnter", "CmdlineEnter" },
}
