local lsp = require('lsp-zero').preset({})
local cmp = require('cmp')

lsp.setup_nvim_cmp({
    preselect = 'none',
    mapping = lsp.defaults.cmp_mappings({
        ['<Tab>']   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    })
})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

vim.diagnostic.config({ virtual_text = false })
