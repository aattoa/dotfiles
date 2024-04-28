---@type fun(comment: string, line: string): string?
local function try_uncomment_line(comment, line)
    local format = comment:gsub(".", "%%%1"):gsub("%%%%%%s", "(.*)")
    local prefix, commented = line:match("(.*)" .. format) ---@type string?, string?
    return commented and assert(prefix) .. commented
end

---@type fun(comment: string, line: string): string
local function uncomment_line(comment, line)
    return try_uncomment_line(comment, line) or line
end

---@type fun(comment: string, line: string): string
local comment_line = string.format

---@type fun(comment: string, line: string): string
local function toggle_comment_line(comment, line)
    return try_uncomment_line(comment, line) or comment_line(comment, line)
end

---@param buffer integer
---@param first integer
---@param last integer
---@param callback fun(comment: string, line: string): string
local function operate_on_range(buffer, first, last, callback)
    local comment = vim.bo[buffer].commentstring ---@type string?
    if not comment or not comment:find("%%s") then
        return -- No comment string available
    end
    local lines = vim.api.nvim_buf_get_lines(buffer, first, last, true) ---@type string[]
    for index, line in ipairs(lines) do
        local whitespace, content = line:match("(%s*)(.*)") ---@type string, string
        lines[index] = assert(whitespace) .. callback(comment, assert(content))
    end
    vim.api.nvim_buf_set_lines(buffer, first, last, true, lines)
end

---@param callback fun(comment: string, line: string): string
local function operate_on_current_line_or_visual_range(callback)
    local mode = vim.api.nvim_get_mode().mode ---@type string
    if mode == "n" then
        local line = vim.api.nvim_win_get_cursor(0)[1] ---@type integer
        operate_on_range(0, line - 1, line + vim.v.count1 - 1, callback)
    elseif mode == "v" or mode == "V" then
        local first, last = require("util.misc").visual_line_range()
        operate_on_range(0, first, last, callback)
    end
end

local M = {}

M.comment = function ()
    operate_on_current_line_or_visual_range(comment_line)
end

M.uncomment = function ()
    operate_on_current_line_or_visual_range(uncomment_line)
end

M.toggle = function ()
    operate_on_current_line_or_visual_range(toggle_comment_line)
end

M.test = function ()
    local comments = {
        "(* %s *)",
        "{- %s -}",
        "-- %s",
        "--[[%s]]",
        "// %s",
        "/*%s*/",
        "# %s",
        "<!--%s-->",
    }
    for _, comment in ipairs(comments) do
        local line = "hello -- world {-{* line#text &]-]"
        require("util.misc").assert_equal(line, uncomment_line(comment, comment_line(comment, line)))
    end
end

return M
