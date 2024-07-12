local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = { completion = { completionItem = { snippetSupport = true } } },
})

return {
    'neovim/nvim-lspconfig',
    config = function ()
        require('lspconfig.ui.windows').default_options.border = vim.g.floatborder
        for _, server in ipairs({ 'clangd', 'rust_analyzer', 'hls', 'pylsp', 'lua_ls', 'gdscript' }) do
            require('lspconfig')[server].setup({
                capabilities = capabilities,
                settings     = require('util.lsp').server_settings,
                cmd          = require('util.lsp').server_commands[server],
            })
        end
        vim.keymap.set('n', '<Leader>ll', '<Cmd>LspInfo<CR>')
    end,
    lazy = false,
}
