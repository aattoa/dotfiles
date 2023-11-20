local lspconfig = require("lspconfig")

---@param client table
---@param buffer integer
local function format_on_save(client, buffer)
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function ()
            vim.lsp.buf.format {
                id    = client.id,
                name  = client.name,
                bufnr = buffer,
            }
        end,
        buffer = buffer,
        desc   = "Automatically format with " .. client.name,
    })
end

local default_lsp_setup_options = {
    on_attach = function (client, buffer)
        if client.server_capabilities.signatureHelpProvider then
            require("lsp-overloads").setup(client, {})
            vim.keymap.set("i", "<C-Space>", vim.cmd.LspOverloadsSignature)
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
        vim.diagnostic.config { virtual_text = true }
        vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename)
        vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action)
        vim.keymap.set("n", "K",          vim.lsp.buf.hover)
        vim.keymap.set("n", "gd",         vim.lsp.buf.definition)
        vim.keymap.set("n", "gD",         vim.lsp.buf.declaration)
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

require("mason").setup {}

require("mason-lspconfig").setup {
    ensure_installed = { "clangd", "cmake", "rust_analyzer", "bashls", "hls", "pylsp", "lua_ls", },
    handlers = {
        function (server)
            lspconfig[server].setup(default_lsp_setup_options)
        end,
        clangd = function ()
            lspconfig.clangd.setup {
                on_attach = function (client, buffer)
                    format_on_save(client, buffer)
                    default_lsp_setup_options.on_attach(client, buffer)
                end,
                capabilities = default_lsp_setup_options.capabilities,
                cmd = { "clangd", "--clang-tidy", "--pch-storage=memory" },
            }
        end,
        lua_ls = function ()
            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        runtime     = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace   = { library = { vim.env.VIMRUNTIME } },
                    }
                },
                on_attach    = default_lsp_setup_options.on_attach,
                capabilities = default_lsp_setup_options.capabilities,
            }
        end,
    }
}
