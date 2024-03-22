---@param buffer integer
---@param line integer 0-indexed
---@return string
local function nth_line(buffer, line)
    ---@type string[]
    local table = vim.api.nvim_buf_get_lines(buffer, line, line + 1, true)
    assert(#table == 1)
    return table[1]
end

---The `Diagnostic` class is specified to have a field `buffer`, but the actual
---tables seem to have `bufnr` instead. This function tries both, just in case.
---@return integer
local function get_buffer(table)
    return assert(table.bufnr or table.buffer)
end

---@param diagnostic Diagnostic
---@return string
local function format_virtual_text(diagnostic)
    if type(diagnostic.code) == "string" then
        return diagnostic.code
    end

    local line    = nth_line(get_buffer(diagnostic), diagnostic.lnum)
    local max_len = math.floor(vim.api.nvim_win_get_width(0) * 0.6) - line:len()

    if max_len < 1 then
        return "..."
    elseif diagnostic.message:len() > max_len then
        return diagnostic.message:sub(1, max_len) .. " ..."
    else
        return diagnostic.message
    end
end

vim.diagnostic.config({
    virtual_text  = { format = format_virtual_text },
    float         = { border = "rounded" },
    severity_sort = true,
})

vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
