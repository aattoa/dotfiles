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
                ["<CR>"]  = cmp.mapping.confirm({ select = false }),
                ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-n>"] = cmp.mapping.scroll_docs(1),
                ["<C-p>"] = cmp.mapping.scroll_docs(-1),
                ["<C-c>"] = function (fallback)
                    if vim.fn.pumvisible() ~= 0 then
                        fallback()
                    elseif cmp.visible() then
                        cmp.abort()
                    else
                        cmp.complete()
                    end
                end,
                ["<C-a>"] = function (fallback)
                    if not cmp.visible() then
                        fallback()
                    elseif cmp.visible_docs() then
                        cmp.close_docs()
                    else
                        cmp.open_docs()
                    end
                end,
            }),
            window = {
                completion    = cmp.config.window.bordered({ scrolloff = 2 }),
                documentation = cmp.config.window.bordered(),
            },
            view = {
                docs = { auto_open = true },
            },
            preselect = cmp.PreselectMode.None,
        })
    end,
    event = { "InsertEnter", "CmdlineEnter" },
}
