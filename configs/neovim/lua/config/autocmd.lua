vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function () vim.highlight.on_yank({ timeout = 100 --[[milliseconds]] }) end,
    desc     = "Briefly highlight yanked text",
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

        config.set_mappings(client, event.buf)
        config.enable_format_on_write(client, event.buf)
        config.enable_highlight_cursor_references(client, event.buf)

        vim.lsp.handlers["textDocument/references"] = vim.lsp.with(vim.lsp.handlers["textDocument/references"], {
            loclist = true, -- Use loclist instead of qflist to keep references separate from diagnostics.
        })
    end,
    desc = "Apply LSP configuration",
})

---@param buffer integer
local function quit_if_last_window(buffer)
    vim.api.nvim_create_autocmd("WinEnter", {
        callback = function ()
            if #vim.api.nvim_list_wins() == 1 then
                vim.cmd.quit()
            end
        end,
        buffer = buffer,
        desc   = "Quit if last window",
    })
end

---@param filetypes string[]
---@param callback fun(buffer: integer): nil
local function filetype(filetypes, callback)
    vim.api.nvim_create_autocmd("FileType", {
        pattern  = filetypes,
        callback = function (event) callback(event.buf) end,
        desc     = "Set local options for " .. table.concat(filetypes, ", "),
    })
end

filetype({ "help", "man" }, function (buffer)
    quit_if_last_window(buffer)
    vim.wo.cursorline = false
    vim.keymap.set("n", "j",  "<C-e>",     { buffer = buffer })
    vim.keymap.set("n", "J", "3<C-e>",     { buffer = buffer })
    vim.keymap.set("n", "k",  "<C-y>",     { buffer = buffer })
    vim.keymap.set("n", "K", "3<C-y>",     { buffer = buffer })
    vim.keymap.set("n", "q", vim.cmd.quit, { buffer = buffer })
end)

filetype({ "qf" }, function (buffer)
    quit_if_last_window(buffer)
    vim.keymap.set("n", "j", "j<Return>zz<C-W>p", { buffer = buffer })
    vim.keymap.set("n", "k", "k<Return>zz<C-W>p", { buffer = buffer })
    vim.keymap.set("n", "q", vim.cmd.quit,        { buffer = buffer })
end)

filetype({ "markdown" }, function (buffer)
    -- Make markdown files by converting them to PDF
    vim.bo[buffer].makeprg = "pandoc % -o %<.pdf &"
end)
