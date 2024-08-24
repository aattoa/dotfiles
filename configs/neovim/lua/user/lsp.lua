local original_open_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function (contents, syntax, options, ...)
    return original_open_floating_preview(contents, syntax, vim.tbl_extend('keep', options or {}, {
        border     = vim.g.floatborder,
        max_height = math.floor(vim.api.nvim_win_get_height(0) / 2),
    }), ...)
end

vim.lsp.handlers['textDocument/references'] = vim.lsp.with(vim.lsp.handlers['textDocument/references'], {
    loclist = true, -- Use loclist instead of qflist to keep references separate from diagnostics.
})

---@param buffer integer?
local function lsp_toggle_inlay_hints(buffer)
    local enable = not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
    vim.lsp.inlay_hint.enable(enable, { bufnr = buffer })
    vim.notify('Inlay hints ' .. (enable and 'enabled' or 'disabled'))
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
local function create_mappings(_, buffer)
    vim.keymap.set('n',          '<leader>li', lsp_toggle_inlay_hints,      { buffer = buffer })
    vim.keymap.set('n',          '<leader>lf', vim.lsp.buf.references,      { buffer = buffer })
    vim.keymap.set('n',          '<leader>lr', vim.lsp.buf.rename,          { buffer = buffer })
    vim.keymap.set('n',          '<leader>la', vim.lsp.buf.code_action,     { buffer = buffer })
    vim.keymap.set('n',          '<leader>ld', vim.lsp.buf.definition,      { buffer = buffer })
    vim.keymap.set('n',          '<leader>lt', vim.lsp.buf.type_definition, { buffer = buffer })
    vim.keymap.set('n',          '<leader>lw', vim.lsp.buf.format,          { buffer = buffer })
    vim.keymap.set('n',          'K',          vim.lsp.buf.hover,           { buffer = buffer })
    vim.keymap.set({ 'n', 'i' }, '<c-space>',  vim.lsp.buf.signature_help,  { buffer = buffer })
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
local function enable_highlight_cursor_references(client, buffer)
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

---@return boolean
local function has_clang_format_file()
    return vim.fs.find(".clang-format", { upward = true, path = vim.fn.expand('%:p:h') })[1] ~= nil
end

---@type fun(client: vim.lsp.Client, buffer: integer): nil
local function enable_format_on_write(client, buffer)
    local ft = vim.bo[buffer].filetype
    if ft ~= 'cpp' and ft ~= 'rust' then
        return -- Do not format languages other than C++ and Rust.
    elseif ft == 'cpp' and not has_clang_format_file() then
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

---@type fun(client: vim.lsp.Client, buffer: integer): nil
local function on_attach(client, buffer)
    create_mappings(client, buffer)
    enable_format_on_write(client, buffer)
    enable_highlight_cursor_references(client, buffer)
end

local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = { completion = { completionItem = { snippetSupport = true } } },
})

---@type fun(name: string, config: ClientConfig, path: string)
local function start_client(name, config, path)
    local root = vim.fs.root(path, config.root) or vim.fs.root(path, '.git') or vim.fs.dirname(path)
    vim.lsp.start({
        name         = name,
        cmd          = config.command,
        cmd_cwd      = root,
        root_dir     = root,
        settings     = config.settings,
        on_attach    = on_attach,
        capabilities = capabilities,
    })
end

local function client_autogroup()
    return vim.api.nvim_create_augroup('my-lsp-client-autogroup', { clear = true })
end

local function client_autostart_enable()
    local group = client_autogroup()
    for name, config in pairs(require('user.clients')) do
        vim.api.nvim_create_autocmd('FileType', {
            callback = function (event) start_client(name, config, event.file) end,
            pattern  = config.filetypes,
            group    = group,
            desc     = "LSP client autostart for " .. name,
        })
    end
end

local function client_autostart_disable()
    client_autogroup()
end

vim.api.nvim_create_user_command('StartLspAutoAttach', client_autostart_enable, {})
vim.api.nvim_create_user_command('StopLspAutoAttach', client_autostart_disable, {})

if vim.g.lspautostart then
    client_autostart_enable()
end
