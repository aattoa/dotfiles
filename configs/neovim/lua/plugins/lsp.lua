---@param client table
---@param buffer integer
local function enable_format_on_save(client, buffer)
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function ()
            if client.name == "clangd" and not next(vim.fs.find(".clang-format", { upward = true, stop = vim.loop.os_homedir() })) then
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

local function highlight_references()
    vim.lsp.buf.document_highlight()
    is_currently_cursor_held = true
end

local function clear_highlights()
    if is_currently_cursor_held then
        vim.lsp.buf.clear_references()
        is_currently_cursor_held = false
    end
end

---@param client table
---@param buffer integer
local function enable_highlight_cursor_references(client, buffer)
    if not client.server_capabilities.documentHighlightProvider then
        return
    end
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = highlight_references,
        buffer   = buffer,
        desc     = "Highlight references to the symbol under the cursor",
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
        callback = clear_highlights,
        buffer   = buffer,
        desc     = "Clear reference highlights when the cursor is moved",
    })
end

---@param buffer integer
local function set_lsp_mappings(buffer)
    vim.keymap.set({ "n", "i" }, "<C-Space>",  vim.lsp.buf.signature_help, { buffer = buffer })
    vim.keymap.set("n",          "<Leader>lr", vim.lsp.buf.rename,         { buffer = buffer })
    vim.keymap.set("n",          "<Leader>la", vim.lsp.buf.code_action,    { buffer = buffer })
    vim.keymap.set("n",          "<Leader>ld", vim.diagnostic.open_float,  { buffer = buffer })
    vim.keymap.set("n",          "K",          vim.lsp.buf.hover,          { buffer = buffer })
    vim.keymap.set("n",          "gd",         vim.lsp.buf.definition,     { buffer = buffer })
    vim.keymap.set("n",          "gD",         vim.lsp.buf.declaration,    { buffer = buffer })
    vim.keymap.set("n",          "]]",         vim.diagnostic.goto_next,   { buffer = buffer })
    vim.keymap.set("n",          "[[",         vim.diagnostic.goto_prev,   { buffer = buffer })
end

---@param callbacks table
---@return function
local function on_attach(callbacks)
    ---@param client table
    ---@param buffer integer
    return function (client, buffer)
        for _, callback in ipairs(callbacks) do
            callback(client, buffer)
        end
        set_lsp_mappings(buffer)
        enable_highlight_cursor_references(client, buffer)
    end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function ()
        local lspconfig    = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        lspconfig.clangd.setup {
            on_attach    = on_attach { enable_format_on_save },
            cmd          = { "clangd", "--clang-tidy" },
            capabilities = capabilities,
        }

        lspconfig.rust_analyzer.setup {
            on_attach    = on_attach { enable_format_on_save },
            capabilities = capabilities,
        }

        lspconfig.lua_ls.setup {
            on_attach = on_attach {},
            settings = {
                Lua = {
                    runtime     = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace   = { library = { vim.env.VIMRUNTIME } },
                }
            },
            capabilities = capabilities,
        }

        for _, server in ipairs { "hls", "pylsp", "bashls", "cmake" } do
            lspconfig[server].setup {
                on_attach    = on_attach {},
                capabilities = capabilities,
            }
        end

        ---@type string
        local lsp_popup_border = "rounded"

        vim.diagnostic.config {
            virtual_text = {
                format = function (diagnostic)
                    -- Avoid annoyingly verbose virtual text by displaying
                    -- only the diagnostic code instead of the full message.
                    return diagnostic.code
                end,
            },
            float = { border = lsp_popup_border },
            severity_sort = true,
        }

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = lsp_popup_border })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = lsp_popup_border })
    end,
    event = { "BufReadPost", "BufNewFile" },
}
