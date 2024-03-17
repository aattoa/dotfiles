local M = {}

M.server_settings = {
    haskell = {
        plugin = {
            stan = { globalOn = false }, -- stan mostly just gets in the way.
        },
    },
    Lua = {
        workspace = {
            library = { vim.env.VIMRUNTIME },
        },
    },
    pylsp = {
        plugins = {
            pylint = { enabled = true },
        },
    },
    ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
    },
}

M.server_commands = {
    clangd = {
        "clangd",
        "--clang-tidy",                -- Enable clang-tidy checks
        "--completion-style=detailed", -- Provide individual completion entries for overloads
        "--header-insertion=never",    -- Do not automatically insert #include directives
        "--log=error",                 -- Do not flood the LSP log with status messages
    },
}

---@param client lsp.Client
---@param buffer integer
M.set_mappings = function (client, buffer)
    vim.keymap.set("n", "<C-Space>",  vim.lsp.buf.signature_help, { buffer = buffer })
    vim.keymap.set("n", "<Leader>lf", vim.lsp.buf.references,     { buffer = buffer })
    vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename,         { buffer = buffer })
    vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action,    { buffer = buffer })
    vim.keymap.set("n", "<Leader>ld", vim.diagnostic.open_float,  { buffer = buffer })
    vim.keymap.set("n", "]]",         vim.diagnostic.goto_next,   { buffer = buffer })
    vim.keymap.set("n", "[[",         vim.diagnostic.goto_prev,   { buffer = buffer })
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,          { buffer = buffer })
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     { buffer = buffer })
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    { buffer = buffer })

    if client.name == "clangd" then
        vim.keymap.set("n", "<Leader>ss", "<Cmd>ClangdSwitchSourceHeader<Return>", { buffer = buffer })
    end
end

---@param client lsp.Client
---@param buffer integer
M.enable_highlight_cursor_references = function (client, buffer)
    if not client.server_capabilities.documentHighlightProvider then
        return
    end
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = vim.lsp.buf.document_highlight,
        buffer   = buffer,
        desc     = "Highlight references to the symbol under the cursor",
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
        callback = vim.lsp.buf.clear_references,
        buffer   = buffer,
        desc     = "Clear reference highlights when the cursor is moved",
    })
end

---@param client lsp.Client
---@param buffer integer
M.enable_format_on_write = function (client, buffer)
    local function has_file(name)
        return next(vim.fs.find(name, { upward = true, stop = vim.loop.os_homedir() }))
    end
    if client.name ~= "clangd" and client.name ~= "rust_analyzer" then
        return -- Do not format languages other than C++ and Rust.
    elseif client.name == "clangd" and not has_file(".clang-format") then
        return -- Do not format with clangd when there is no clang-format file.
    end
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function ()
            vim.lsp.buf.format({
                id    = client.id,
                name  = client.name,
                bufnr = buffer,
            })
        end,
        buffer = buffer,
        desc   = "Automatically format file with " .. client.name,
    })
end

return M
