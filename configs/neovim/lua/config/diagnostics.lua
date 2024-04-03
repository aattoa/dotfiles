---@param buffer integer
---@param line integer 0-indexed
---@return string
local function nth_line(buffer, line)
    ---@type string[]
    local lines = vim.api.nvim_buf_get_lines(buffer, line, line + 1, true)
    assert(#lines == 1)
    return lines[1]
end

---The `Diagnostic` class is specified to have a field `buffer`, but the actual
---tables seem to have `bufnr` instead. This function tries both, just in case.
---@return integer
local function get_buffer(diagnostic)
    return assert(diagnostic.bufnr or diagnostic.buffer)
end

---@param text string
---@param line string
local function crop_virtual_text(text, line)
    local max_len = math.floor(vim.api.nvim_win_get_width(0) * 0.6) - line:len()
    if max_len < 1 then
        return "..."
    elseif text:len() > max_len then
        return text:sub(1, max_len) .. " ..."
    else
        return text
    end
end

---@param diagnostic Diagnostic
---@return string
local function format_virtual_text(diagnostic)
    if type(diagnostic.code) == "string" then
        return diagnostic.code
    else
        return crop_virtual_text(diagnostic.message, nth_line(get_buffer(diagnostic), diagnostic.lnum))
    end
end

vim.diagnostic.config({
    virtual_text  = { format = format_virtual_text },
    float         = { border = "rounded" },
    severity_sort = true,
})

vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
