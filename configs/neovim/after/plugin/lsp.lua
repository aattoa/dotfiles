local lsp = require("lsp-zero").preset({})
local cmp = require("cmp")

lsp.setup_nvim_cmp({
    sources = {
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" },
    },
    mapping = lsp.defaults.cmp_mappings({
        ["<Tab>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    }),
    preselect = cmp.PreselectMode.None,
})

lsp.on_attach(function(client, bufnr)
    if client.server_capabilities.signatureHelpProvider then
        require('lsp-overloads').setup(client, {})
    end
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat(client, bufnr, {
        -- Do not automatically format lua files
        filter = function(client_) return client_.name ~= "lua_ls" end
    })
    vim.diagnostic.config({ virtual_text = true })
end)

lsp.setup()
