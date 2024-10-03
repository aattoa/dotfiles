local cpp_formatter = [[template <$1>
struct std::formatter<$2> {
    static constexpr auto parse(auto& context) {
        return context.begin();
    }
    static auto format($2 const& $3, auto& context) {
        return std::format_to(context.out(), "$4", $0);
    }
};]]

local cmake_fetch = [[FetchContent_Declare(${1:library}
    GIT_REPOSITORY https://github.com/$2/$1.git
    GIT_TAG        ${3:tag})
FetchContent_MakeAvailable($1)]]

return {
    all = {
        date = function () return os.date('%F') end,
        time = function () return os.date('%T') end,
    },
    haskell = {
        fn = '${1:name} :: ${2:type}\n$1 $3 = ${4:undefined}',
    },
    python = {
        main = 'def ${1:main}():\n\t$0\n\nif __name__ == "__main__":\n\t$1()',
    },
    lua = {
        inspect = 'vim.notify(vim.inspect($0))',
    },
    rust = {
        derive = '#[derive(${1:Debug})]',
        tests  = '#[cfg(test)]\nmod tests {\n\tuse super::*;\n\n\t$0\n}',
        test   = '#[test]\nfn ${1:test-name}() {\n\t$0\n}',
    },
    cpp = {
        fmt     = cpp_formatter,
        ['for'] = 'for (${1|auto,int,std::size_t|} ${2:i} = ${3:0}; $2 != $4; ++$2) {\n\t$0\n}',
        lam     = '[$1]($2)\n\tnoexcept(noexcept($3)) -> decltype($3)\n{\n\treturn $3;\n}',
        arm     = 'auto operator()($1) {\n\t$0\n}',
        fn      = 'auto ${1:function-name}($2) -> ${3:return-type} {\n\t$0\n}',
        fwd     = 'std::forward<decltype($1)>($1)',
        mv      = 'std::move($1)',
        to      = 'std::ranges::to<${1:std::vector}>()',
        r       = 'std::ranges::',
        v       = 'std::views::',
        c       = 'std::chrono::',
        f       = 'std::filesystem::',
        tod     = 'cpputil::todo()',
    },
    cmake = {
        ['for'] = 'foreach ($1)\n\t$0\nendforeach ()',
        ['if']  = 'if (${1:condition})\n\t$0\nendif ()',
        fn      = 'function (${1:function-name})\n\t$0\nendfunction ()',
        fetch   = cmake_fetch,
    },
    gdscript = {
        fn = 'func ${1:function-name}($2) -> $3:\n\t${4:pass}',
    },
    sh = {
        ['if'] = 'if $1; then\n\t$0\nfi',
        err    = 'echo "$1" 1>&2',
        case   = 'case $1 in\n\t$2)\n\t\t$3;;\n\t*)\n\t\t$0;;\nesac',
        fn     = '${1:function-name} () {\n\t$0\n}',
    },
    markdown = {
        ln = '[$1](https://$1)',
    },
    tex = {
        block = '\\begin{$1}\n$0\n\\end{$1}',
    },
}
