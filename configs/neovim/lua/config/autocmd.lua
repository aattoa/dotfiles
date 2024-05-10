vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function () vim.highlight.on_yank({ timeout = 100 --[[milliseconds]] }) end,
    desc     = "Briefly highlight yanked text",
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function () vim.diagnostic.setqflist({ open = false }) end,
    desc     = "Keep the quickfix list up to date",
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern  = "make",
    callback = function (event)
        local ns = vim.api.nvim_create_namespace("my-quickfix-list-diagnostics")
        vim.diagnostic.set(ns, event.buf, vim.diagnostic.fromqflist(vim.fn.getqflist()))
    end,
    desc = "Convert quickfix list to diagnostics",
})

vim.api.nvim_create_autocmd({ "WinResized", "LspAttach" }, {
    callback = require("util.lsp").configure_handlers,
    desc     = "Keep LSP handler configuration up to date",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
        require("util.lsp").set_mappings(client, event.buf)
        require("util.lsp").enable_format_on_write(client, event.buf)
        require("util.lsp").enable_highlight_cursor_references(client, event.buf)
    end,
    desc = "Apply LSP configuration",
})

vim.api.nvim_create_autocmd({ "WinNew", "VimEnter" }, {
    command = [[call matchadd('Todo', '\ctodo\|\cfixme\|\cnocommit')]],
    desc    = "Define highlight matches for special text markers",
})

---@param filetypes string[]|string
---@param callback fun(buffer: integer): nil
local function filetype(filetypes, callback)
    vim.api.nvim_create_autocmd("FileType", {
        pattern  = filetypes,
        callback = function (event) callback(event.buf) end,
        desc     = "Set local options for " .. vim.inspect(filetypes),
    })
end

filetype({ "help", "man" }, function (buffer)
    vim.opt_local.cursorline = false
    vim.keymap.set("n", "J", "3<C-e>",     { buffer = buffer })
    vim.keymap.set("n", "K", "3<C-y>",     { buffer = buffer })
    vim.keymap.set("n", "q", vim.cmd.quit, { buffer = buffer })
end)

filetype("qf", function (buffer)
    vim.api.nvim_create_autocmd("WinEnter", {
        command = "if winnr('$') == 1 | quit | endif",
        buffer  = buffer,
        desc    = "Quit if last window",
    })
    vim.keymap.set("n", "J", "j<CR>zz<C-w>p", { buffer = buffer })
    vim.keymap.set("n", "K", "k<CR>zz<C-w>p", { buffer = buffer })
    vim.keymap.set("n", "q", vim.cmd.quit,    { buffer = buffer })
end)

filetype("sh", function (buffer)
    vim.cmd("compiler shellcheck")
    vim.api.nvim_create_autocmd("BufWritePost", {
        command = "silent make! %",
        buffer  = buffer,
        desc    = "Keep shellcheck diagnostics up to date",
    })
end)

filetype("cpp", function (buffer)
    if vim.version().minor < 10 then return end
    vim.keymap.set("ia", "f:", "std::filesystem:", { buffer = buffer })
    vim.keymap.set("ia", "c:", "std::chrono:",     { buffer = buffer })
    vim.keymap.set("ia", "r:", "std::ranges:",     { buffer = buffer })
    vim.keymap.set("ia", "v:", "std::views:",      { buffer = buffer })
end)

filetype({ "c", "cpp", "rust" }, function (buffer)
    vim.bo[buffer].commentstring = "// %s"
    if vim.version().minor < 10 then return end
    vim.keymap.set("ia", "--", "//", { buffer = buffer })
end)
