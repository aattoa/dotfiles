local M = {}

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
        main = "def ${1:main}():\n\t${2:pass}\n\nif __name__ == \"__main__\":\n\t$1()",
    },
    rust = {
        derive = "#[derive(${1:Debug})]",
        tests  = "#[cfg(test)]\nmod tests {\n\tuse super::*;\n\n\t$1\n}",
        test   = "#[test]\nfn ${1:test-name}() {\n\t$2\n}",
    },
    cpp = {
        formatter = [[template <$1>
struct std::formatter<$2> {
    static constexpr auto parse(auto& context) {
        return context.begin();
    }
    static auto format($2 const& $3, auto& context) {
        return std::format_to(context.out(), "$4", $5);
    }
};]],
        ["for"] = "for (std::size_t ${1:i} = ${2:0}; $1 != $3; ++$1) {\n\t$4\n}",
        fn      = "auto ${1:function-name}($2) -> $3 {\n\t$4\n}",
        mv      = "std::move($1)",
        to      = "std::ranges::to<${1:std::vector}>()",
    },
    sh = {
        ["if"] = "if $1; then\n\t$2\nfi",
        err    = "echo \"$1\" 1>&2",
        case   = "case $1 in\n\t$2)\n\t\t$3;;\n\t*)\n\t\t$4;;\nesac",
        fn     = "${1:function-name} () {\n\t$2\n}",
    },
    markdown = {
        link = "[$1]($1)",
    },
}

---@type fun(line: string): string?, integer?
local function simple_word_suffix(line)
    local word, prefix = line:reverse():match("(%a+)(.*)") ---@type string?, string?
    return word and word:reverse(), prefix and prefix:len()
end

---@type fun(filetype: string, name: string): util.snippet.Snippet
local function find_snippet(filetype, name)
    local snippets = M.snippets[filetype]
    return snippets and snippets[name]
end

---@type fun(snippet: util.snippet.Snippet): string?
local function snippet_body(snippet)
    if type(snippet) == "string" then
        return snippet
    elseif type(snippet) == "function" then
        return snippet()
    end
end

---@return boolean
local function try_expand_snippet_before_cursor()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local name, offset = simple_word_suffix(line:sub(1, cursor[2]))

    local snippet = name and (find_snippet(vim.bo.filetype, name) or find_snippet("all", name))
    if not snippet then return false end
    assert(name and offset)

    vim.api.nvim_set_current_line(require("util.misc").string_erase(line, offset, offset + name:len()))
    vim.api.nvim_win_set_cursor(0, { cursor[1], offset })
    vim.snippet.expand(assert(snippet_body(snippet)))

    return true
end

M.expand_or_jump = function ()
    if not try_expand_snippet_before_cursor() then
        vim.snippet.jump(1)
    end
end

return M
