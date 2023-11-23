local lspconfig = require("lspconfig")

---@param client table
---@param buffer integer
local function enable_format_on_save(client, buffer)
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function ()
            vim.lsp.buf.format {
                id    = client.id,
                name  = client.name,
                bufnr = buffer,
            }
        end,
        buffer = buffer,
        desc   = "Automatically format file with " .. client.name,
    })
end

---@type boolean
local is_currently_cursor_held = false

---@param client table
---@param buffer integer
local function enable_highlight_cursor_references(client, buffer)
    if not client.server_capabilities.documentHighlightProvider then
        return
    end
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function ()
            vim.lsp.buf.document_highlight()
            is_currently_cursor_held = true
        end,
        buffer = buffer,
        desc   = "Highlight references to the symbol under the cursor",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function ()
            if is_currently_cursor_held then
                vim.lsp.buf.clear_references()
                is_currently_cursor_held = false
            end
        end,
        buffer = buffer,
        desc   = "Clear reference highlights when the cursor is moved",
    })
end

---@param client table
local function set_lsp_mappings(client)
    if client.server_capabilities.signatureHelpProvider then
        require("lsp-overloads").setup(client, {})
        vim.keymap.set("i", "<C-Space>", vim.cmd.LspOverloadsSignature)
    end
    vim.keymap.set("n", "<C-Space>",  vim.lsp.buf.signature_help)
    vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename)
    vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<Leader>ld", vim.diagnostic.open_float)
    vim.keymap.set("n", "]d",         vim.diagnostic.goto_next)
    vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev)
    vim.keymap.set("n", "K",          vim.lsp.buf.hover)
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition)
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration)
end

---@type table
local default_lsp_setup_options = {
    on_attach = function (client, buffer)
        enable_highlight_cursor_references(client, buffer)
        set_lsp_mappings(client)
        vim.diagnostic.config { virtual_text = true }
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

require("mason").setup {
    ui = {
        icons = {
            package_installed   = "I",
            package_pending     = "P",
            package_uninstalled = "U",
        },
        keymaps = {
            update_package      = "r",
            update_all_packages = "R",
            uninstall_package   = "u",
            toggle_help         = "?",
        },
        border = "double",
    }
}

require("mason-lspconfig").setup {
    ensure_installed = { "clangd", "cmake", "rust_analyzer", "bashls", "hls", "pylsp", "lua_ls", },
    handlers = {
        function (server)
            lspconfig[server].setup(default_lsp_setup_options)
        end,
        clangd = function ()
            lspconfig.clangd.setup {
                on_attach = function (client, buffer)
                    enable_format_on_save(client, buffer)
                    default_lsp_setup_options.on_attach(client, buffer)
                end,
                capabilities = default_lsp_setup_options.capabilities,
                cmd          = { "clangd", "--clang-tidy" },
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

vim.keymap.set("n", "<Leader>ll", vim.cmd.Mason)
