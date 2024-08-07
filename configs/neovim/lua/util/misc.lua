local M = {}

---@return integer, integer
M.visual_line_range = function ()
    local a = vim.fn.line('v') ---@type integer
    local b = vim.api.nvim_win_get_cursor(0)[1] ---@type integer
    if a < b then return a - 1, b else return b - 1, a end
end

---@type fun(name: string): string?
M.find_file = function (name)
    ---@diagnostic disable-next-line: undefined-field
    return vim.fs.find(name, { upward = true, path = vim.fn.expand('%:p:h'), stop = vim.loop.os_homedir() })[1]
end

---@type fun(a: any, b: any): nil
M.assert_equal = function (a, b)
    assert(a == b, string.format('%s ~= %s', vim.inspect(a), vim.inspect(b)))
end

return M
