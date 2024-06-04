local M = {}

M.server_settings = {
    haskell = {
        plugin = {
            stan = { globalOn = false }, -- stan mostly just gets in the way.
        },
    },
    Lua = {
        runtime = {
            version = 'LuaJIT',
        },
        workspace = {
            library = { vim.env.VIMRUNTIME },
        },
    },
    pylsp = {
        plugins = {
            pylint = { enabled = true },
        },
    },
    ['rust-analyzer'] = {
        checkOnSave = { command = 'clippy' },
    },
}

M.server_commands = {
    clangd = {
        'clangd',
        '--clang-tidy',                -- Enable clang-tidy checks
        '--completion-style=detailed', -- Provide individual completion entries for overloads
        '--header-insertion=never',    -- Do not automatically insert #include directives
        '--log=error',                 -- Do not flood the LSP log with status messages
    },
}

---@param buffer integer?
local function lsp_toggle_inlay_hints(buffer)
    local enable = not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
    vim.lsp.inlay_hint.enable(enable, { bufnr = buffer })
    vim.notify('Inlay hints ' .. (enable and 'enabled' or 'disabled'))
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
M.set_mappings = function (client, buffer) ---@diagnostic disable-line: unused-local
    vim.keymap.set('n',          '<Leader>ls', '<Cmd>ClangdSwitchSourceHeader<CR>', { buffer = buffer })
    vim.keymap.set('n',          '<Leader>li', lsp_toggle_inlay_hints,              { buffer = buffer })
    vim.keymap.set('n',          '<Leader>lf', vim.lsp.buf.references,              { buffer = buffer })
    vim.keymap.set('n',          '<Leader>lr', vim.lsp.buf.rename,                  { buffer = buffer })
    vim.keymap.set('n',          '<Leader>la', vim.lsp.buf.code_action,             { buffer = buffer })
    vim.keymap.set('n',          '<Leader>ld', vim.lsp.buf.definition,              { buffer = buffer })
    vim.keymap.set('n',          '<Leader>lt', vim.lsp.buf.type_definition,         { buffer = buffer })
    vim.keymap.set('n',          'K',          vim.lsp.buf.hover,                   { buffer = buffer })
    vim.keymap.set({ 'n', 'i' }, '<C-Space>',  vim.lsp.buf.signature_help,          { buffer = buffer })

    if client.server_capabilities.signatureHelpProvider then
        -- Send signature help request on '('
        vim.keymap.set('i', '(', '(<C-Space>', { buffer = buffer, remap = true })
    end
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
M.enable_highlight_cursor_references = function (client, buffer)
    if not client.server_capabilities.documentHighlightProvider then
        return
    end
    vim.api.nvim_create_autocmd('CursorHold', {
        callback = vim.lsp.buf.document_highlight,
        buffer   = buffer,
        desc     = 'Highlight references to the symbol under the cursor',
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter' }, {
        callback = vim.lsp.buf.clear_references,
        buffer   = buffer,
        desc     = 'Clear reference highlights when the cursor is moved',
    })
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
M.enable_format_on_write = function (client, buffer)
    local ft = vim.bo[buffer].filetype
    if ft ~= 'cpp' and ft ~= 'rust' then
        return -- Do not format languages other than C++ and Rust.
    elseif ft == 'cpp' and not require('util.misc').find_file('.clang-format') then
        return -- Do not format C++ files when there is no clang-format file.
    end
    vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function ()
            vim.lsp.buf.format({ id = client.id, bufnr = buffer })
        end,
        buffer = buffer,
        desc   = 'Format with ' .. client.name .. ' before saving',
    })
end

M.configure_floating_windows = function ()
    local original_open_floating_preview = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.util.open_floating_preview = function (contents, syntax, options, ...)
        return original_open_floating_preview(contents, syntax, vim.tbl_extend('keep', options or {}, {
            border     = vim.g.floatborder,
            max_height = math.floor(vim.api.nvim_win_get_height(0) / 2),
        }), ...)
    end
end

M.configure_request_handlers = function ()
    local references = 'textDocument/references'
    vim.lsp.handlers[references] = vim.lsp.with(vim.lsp.handlers[references], {
        loclist = true, -- Use loclist instead of qflist to keep references separate from diagnostics.
    })
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
M.on_attach = function (client, buffer)
    M.set_mappings(client, buffer)
    M.enable_format_on_write(client, buffer)
    M.enable_highlight_cursor_references(client, buffer)
    M.configure_floating_windows()
    M.configure_request_handlers()
end

return M
