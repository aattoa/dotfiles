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
local function make_on_attach_callback(callbacks)
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

---@class ServerSetupArguments
---@field command table|nil
---@field settings table|nil
---@field on_attach_callbacks table|nil

---@param server string
---@param args ServerSetupArguments|nil
local function setup_server(server, args)
    require("lspconfig")[server].setup {
        on_attach    = make_on_attach_callback(args and args.on_attach_callbacks or {}),
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        cmd          = args and args.command,
        settings     = args and args.settings,
    }
end

return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function ()
        setup_server("clangd", {
            on_attach_callbacks = { enable_format_on_save },
            command             = { "clangd", "--clang-tidy" },
        })

        setup_server("rust_analyzer", {
            on_attach_callbacks = { enable_format_on_save },
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = { command = "clippy" },
                },
            },
        })

        setup_server("lua_ls", {
            settings = {
                Lua = {
                    runtime     = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace   = { library = { vim.env.VIMRUNTIME } },
                },
            },
        })

        for _, server in ipairs { "hls", "pylsp", "bashls", "cmake" } do
            setup_server(server)
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
