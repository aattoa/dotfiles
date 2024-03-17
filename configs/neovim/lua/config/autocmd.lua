vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function () vim.highlight.on_yank({ timeout = 100 --[[milliseconds]] }) end,
    desc     = "Briefly highlight yanked text",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern  = "markdown",
    callback = function () vim.bo.makeprg = "pandoc % -o %<.pdf &" end,
    desc     = "Make markdown files by converting them to PDF",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern  = { "help", "man" },
    callback = function (event)
        vim.keymap.set("n", "J", "3j",                 { buffer = event.buf })
        vim.keymap.set("n", "K", "3k",                 { buffer = event.buf })
        vim.keymap.set("n", "q", "<Cmd>close<Return>", { buffer = event.buf })
        vim.wo.cursorline = false
        vim.wo.scrolloff  = 999 -- Keep the cursor centered.
    end,
    desc = "Set documentation options and mappings",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern  = "qf",
    callback = function (event)
        vim.api.nvim_create_autocmd("WinEnter", {
            callback = function ()
                if #vim.api.nvim_list_wins() == 1 then
                    vim.cmd.quit()
                end
            end,
            buffer = event.buf,
            desc   = "Close the quickfix window if no other windows are open",
        })
        vim.keymap.set("n", "<Return>", "<Return>zz",         { buffer = event.buf })
        vim.keymap.set("n", "q",        "<Cmd>close<Return>", { buffer = event.buf })
        vim.keymap.set("n", "j",        "j<Return>zz<C-W>p",  { buffer = event.buf })
        vim.keymap.set("n", "k",        "k<Return>zz<C-W>p",  { buffer = event.buf })
    end,
    desc = "Set quickfix options and mappings",
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function () vim.diagnostic.setqflist({ open = false }) end,
    desc     = "Keep the quickfix list up to date",
})

vim.api.nvim_create_autocmd({ "WinResized", "LspAttach" }, {
    callback = function ()
        local options = {
            border     = "rounded",
            max_width  = 100,
            max_height = math.floor(vim.api.nvim_win_get_height(0) / 3),
        }
        vim.lsp.handlers["textDocument/hover"]         = vim.lsp.with(vim.lsp.handlers.hover, options)
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, options)
    end,
    desc = "Set and update LSP floating window settings",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (event)
        local config = require("config.lsp")
        local client = vim.lsp.get_client_by_id(event.data.client_id) ---@type lsp.Client
        local buffer = event.buf ---@type integer

        config.set_mappings(client, buffer)
        config.enable_format_on_write(client, buffer)
        config.enable_highlight_cursor_references(client, buffer)

        local references = vim.lsp.handlers["textDocument/references"]
        vim.lsp.handlers["textDocument/references"] = vim.lsp.with(references, {
            loclist = true, -- Use location list instead of quickfix list
        })
    end,
    desc = "Apply LSP configuration",
})
