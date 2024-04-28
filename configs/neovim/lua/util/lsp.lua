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

---@type fun(client: vim.lsp.Client, buffer: integer): nil
M.set_mappings = function (client, buffer)
    vim.keymap.set("n", "<Leader>lf", vim.lsp.buf.references,  { buffer = buffer })
    vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename,      { buffer = buffer })
    vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, { buffer = buffer })
    vim.keymap.set("n", "<Leader>ld", vim.lsp.buf.definition,  { buffer = buffer })
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,       { buffer = buffer })

    vim.keymap.set({ "n", "i" }, "<C-Space>", vim.lsp.buf.signature_help, { buffer = buffer })

    if client.name == "clangd" then
        vim.keymap.set("n", "<Leader>ss", "<Cmd>ClangdSwitchSourceHeader<CR>", { buffer = buffer })
    end
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
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

---@type fun(client: vim.lsp.Client, buffer: integer): nil
M.enable_format_on_write = function (client, buffer)
    if client.name ~= "clangd" and client.name ~= "rust_analyzer" then
        return -- Do not format languages other than C++ and Rust.
    elseif client.name == "clangd" and not require("util.misc").find_file(".clang-format") then
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

---@type fun(): nil
M.configure_handlers = function ()
    vim.lsp.handlers["textDocument/references"] = vim.lsp.with(vim.lsp.handlers["textDocument/references"], {
        loclist = true, -- Use loclist instead of qflist to keep references separate from diagnostics.
    })
    local options = {
        border     = "rounded",
        max_width  = 100,
        max_height = math.floor(vim.api.nvim_win_get_height(0) / 3),
    }
    vim.lsp.handlers["textDocument/hover"]         = vim.lsp.with(vim.lsp.handlers.hover, options)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, options)
end

return M
