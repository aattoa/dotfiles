---@param client table
---@param buffer integer
local function enable_format_on_save(client, buffer)
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function ()
            if client.name == "clangd" and vim.fn.findfile(".clang-format", ".;") == "" then
                return -- Do not format with clangd when there is no clang-format file.
            end
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

local function configure_diagnostics()
    vim.diagnostic.config {
        virtual_text = {
            format = function (diagnostic)
                -- Avoid annoyingly verbose virtual text by displaying
                -- only the diagnostic code instead of the full message.
                return diagnostic.code
            end,
        },
        float = { border = "rounded" },
        severity_sort = true,
    }
end

local function set_lsp_mappings()
    vim.keymap.set({ "n", "i" }, "<C-Space>",  vim.lsp.buf.signature_help)
    vim.keymap.set("n",          "<Leader>lr", vim.lsp.buf.rename)
    vim.keymap.set("n",          "<Leader>la", vim.lsp.buf.code_action)
    vim.keymap.set("n",          "<Leader>ld", vim.diagnostic.open_float)
    vim.keymap.set("n",          "]]",         vim.diagnostic.goto_next)
    vim.keymap.set("n",          "[[",         vim.diagnostic.goto_prev)
    vim.keymap.set("n",          "K",          vim.lsp.buf.hover)
    vim.keymap.set("n",          "gd",         vim.lsp.buf.definition)
    vim.keymap.set("n",          "gD",         vim.lsp.buf.declaration)
end

---@param client table
---@param buffer integer
local function default_on_attach(client, buffer)
    enable_highlight_cursor_references(client, buffer)
    configure_diagnostics()
    set_lsp_mappings()
end

---@param server string
local function lspconfig(server)
    return require("lspconfig")[server]
end

local function default_capabilities()
    return require("cmp_nvim_lsp").default_capabilities()
end

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/nvim-cmp",
    },
    opts = {
        ensure_installed = { "clangd", "cmake", "rust_analyzer", "bashls", "hls", "pylsp", "lua_ls" },
        handlers = {
            function (server)
                lspconfig(server).setup {
                    on_attach    = default_on_attach,
                    capabilities = default_capabilities(),
                }
            end,
            clangd = function ()
                lspconfig("clangd").setup {
                    on_attach = function (client, buffer)
                        default_on_attach(client, buffer)
                        enable_format_on_save(client, buffer)
                    end,
                    capabilities = default_capabilities(),
                    cmd          = { "clangd", "--clang-tidy" },
                }
            end,
            lua_ls = function ()
                lspconfig("lua_ls").setup {
                    settings = {
                        Lua = {
                            runtime     = { version = "LuaJIT" },
                            diagnostics = { globals = { "vim" } },
                            workspace   = { library = { vim.env.VIMRUNTIME } },
                        }
                    },
                    on_attach    = default_on_attach,
                    capabilities = default_capabilities(),
                }
            end,
        }
    },
    event = { "BufReadPost", "BufNewFile" },
}
