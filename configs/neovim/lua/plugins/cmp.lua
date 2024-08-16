return {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function ()
        local cmp = require('cmp')
        cmp.setup({
            sources = { { name = 'nvim_lsp' } },
            mapping = cmp.mapping.preset.insert({
                ['<cr>']  = cmp.mapping.confirm({ select = false }),
                ['<c-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<c-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<c-n>'] = cmp.mapping.scroll_docs(1),
                ['<c-p>'] = cmp.mapping.scroll_docs(-1),
                ['<c-c>'] = function (fallback)
                    if vim.fn.pumvisible() ~= 0 then
                        fallback()
                    elseif cmp.visible() then
                        cmp.abort()
                    else
                        cmp.complete()
                    end
                end,
                ['<c-a>'] = function (fallback)
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
                completion    = cmp.config.window.bordered({ border = vim.g.floatborder, scrolloff = 2 }),
                documentation = cmp.config.window.bordered({ border = vim.g.floatborder }),
            },
            view = {
                docs = {
                    auto_open = false,
                },
                entries = 'native',
            },
            preselect = cmp.PreselectMode.None,
        })
    end,
    event = 'InsertEnter',
}
