---@type fun(text: string, line: string): string
local function crop_virtual_text(text, line)
    local max_len = math.floor(vim.api.nvim_win_get_width(0) * 0.7) - line:len()
    if max_len < 1 then
        return "..."
    elseif text:len() > max_len then
        return text:sub(1, max_len) .. " ..."
    else
        return text
    end
end

---@type fun(diagnostic: vim.Diagnostic): string
local function format_virtual_text(diagnostic)
    if type(diagnostic.code) == "string" then
        return diagnostic.code ---@type string
    end
    local line = require("util.misc").nth_line(diagnostic.bufnr, diagnostic.lnum)
    return crop_virtual_text(diagnostic.message, line)
end

vim.diagnostic.config({
    virtual_text  = { format = format_virtual_text },
    float         = { border = "rounded" },
    severity_sort = true,
})

vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_next)
vim.keymap.set("n", "<C-p>", vim.diagnostic.goto_prev)
