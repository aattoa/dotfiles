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
        ["<C-j>"]   = cmp.mapping.scroll_docs(1),
        ["<C-k>"]   = cmp.mapping.scroll_docs(-1),
    }),
    preselect = cmp.PreselectMode.None,
})

lsp.on_attach(function(client, buffer)
    lsp.default_keymaps({ buffer = buffer })
    vim.diagnostic.config({ virtual_text = true })

    if client.server_capabilities.signatureHelpProvider then
        require("lsp-overloads").setup(client, {})
    end

    if client.name == "clangd" then
        lsp.buffer_autoformat(client, buffer)
    end

    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer   = buffer,
            desc     = "Highlight references to the symbol under the cursor",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer   = buffer,
            desc     = "Clear reference highlights when the cursor is moved",
        })
    end
end)

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

lsp.setup()
