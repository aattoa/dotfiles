local M = {}

local cpp_formatter = [[template <$1>
struct std::formatter<$2> {
    static constexpr auto parse(auto& context) {
        return context.begin();
    }
    static auto format($2 const& $3, auto& context) {
        return std::format_to(context.out(), "$4", $0);
    }
};]]

local cmake_fetch = [[FetchContent_Declare(
    ${1:library}
    GIT_REPOSITORY https://github.com/$2/$1.git
    GIT_TAG        ${3:tag})
FetchContent_MakeAvailable($1)]]

local cmake_cpp = [[set(CMAKE_CXX_STANDARD            ${1|23,20,17,14,11|})
set(CMAKE_CXX_STANDARD_REQUIRED   ON)
set(CMAKE_CXX_EXTENSIONS          OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)]]

---@alias util.snippet.Snippet string|fun():string

---@type table<string, table<string, util.snippet.Snippet>>
M.snippets = {
    all = {
        date = function () return os.date("%F") end, ---@diagnostic disable-line: return-type-mismatch
        time = function () return os.date("%T") end, ---@diagnostic disable-line: return-type-mismatch
    },
    haskell = {
        fn = "${1:name} :: ${2:type}\n$1 = ${3:undefined}",
    },
    python = {
        main = "def ${1:main}():\n\t$0\n\nif __name__ == \"__main__\":\n\t$1()",
    },
    rust = {
        derive = "#[derive(${1:Debug})]",
        tests  = "#[cfg(test)]\nmod tests {\n\tuse super::*;\n\n\t$0\n}",
        test   = "#[test]\nfn ${1:test-name}() {\n\t$0\n}",
    },
    cpp = {
        fmt     = cpp_formatter,
        ["for"] = "for (${1|int,std::size_t|} ${2:i} = ${3:0}; $2 != $4; ++$2) {\n\t$0\n}",
        fn      = "auto ${1:function-name}($2) -> $3 {\n\t$0\n}",
        mv      = "std::move($1)",
        to      = "std::ranges::to<${1:std::vector}>()",
    },
    cmake = {
        ["for"] = "foreach ($1)\n\t$0\nendforeach ()",
        ["if"]  = "if (${1:condition})\n\t$0\nendif ()",
        fn      = "function (${1:function-name})\n\t$0\nendfunction ()",
        fetch   = cmake_fetch,
        cpp     = cmake_cpp,
    },
    sh = {
        ["if"] = "if $1; then\n\t$0\nfi",
        err    = "echo \"$1\" 1>&2",
        case   = "case $1 in\n\t$2)\n\t\t$3;;\n\t*)\n\t\t$0;;\nesac",
        fn     = "${1:function-name} () {\n\t$0\n}",
    },
    markdown = {
        ln = "[$1](https://$1)",
    },
}

---@type fun(filetype: string, name: string): util.snippet.Snippet?
local function find_snippet(filetype, name)
    local snippets = M.snippets[filetype]
    return snippets and snippets[name] or M.snippets.all[name]
end

---@type fun(snippet: util.snippet.Snippet): string?
local function snippet_body(snippet)
    if type(snippet) == "string" then
        return snippet
    elseif type(snippet) == "function" then
        return snippet()
    end
end

---@type fun(column: integer): nil
local function set_cursor_column(column)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], column })
end

---@type fun(offset: integer, length: integer): nil
local function erase_range_on_current_line(offset, length)
    local line = vim.api.nvim_get_current_line()
    line = require("util.misc").string_erase(line, offset, offset + length)
    vim.api.nvim_set_current_line(line)
end

---@type fun(name: string, offset: integer): boolean
local function expand_snippet_before_cursor(name, offset)
    local snippet = find_snippet(vim.bo.filetype, name)
    if not snippet then return false end
    erase_range_on_current_line(offset, name:len())
    set_cursor_column(offset)
    vim.snippet.expand(assert(snippet_body(snippet)))
    return true
end

---@type fun(line: string): string?, integer?
local function simple_word_suffix(line)
    local word, prefix = line:reverse():match("^(%a+)(.*)") ---@type string?, string?
    return word and word:reverse(), prefix and prefix:len()
end

---@return boolean
local function find_and_expand_snippet_before_cursor()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local name, offset = simple_word_suffix(line:sub(1, cursor[2]))
    return name and expand_snippet_before_cursor(name, assert(offset)) or false
end

-- If there is a snippet name before the cursor, expand it.
-- Otherwise jump to the next snippet tabstop.
M.expand_or_jump = function ()
    if not find_and_expand_snippet_before_cursor() then
        vim.snippet.jump(1)
    end
end

-- Display available snippets in a popup-menu, and expand the selection.
M.complete = function ()
    local snippets = vim.tbl_extend("force", M.snippets.all or {}, M.snippets[vim.bo.filetype] or {})
    local column = vim.fn.col(".")
    vim.fn.complete(column, vim.tbl_keys(snippets))
    vim.api.nvim_create_autocmd("CompleteDone", {
        callback = function ()
            local word = vim.v.completed_item.word ---@type string?
            if word and #word ~= 0 then
                assert(expand_snippet_before_cursor(word, column - 1))
            end
        end,
        buffer = vim.api.nvim_get_current_buf(),
        once   = true,
    })
end

return M
