local cpp_formatter = [[template <$1>
struct std::formatter<$2> {
    static constexpr auto parse(auto& context) {
        return context.begin();
    }
    static auto format($2 const& $3, auto& context) {
        return std::format_to(context.out(), "$4", $0);
    }
};]]

return {
    all = {
        date  = function () return os.date('%F') end,
        time  = function () return os.date('%T') end,
        tag   = '<$1>$0</$1>',
        guard = '#ifndef $1\n#define $1\n\n$0\n\n#endif // $1',
    },
    haskell = {
        fn = '${1:name} :: ${2:type}\n$1 $0',
        lang = '{-# LANGUAGE $0 #-}',
    },
    python = {
        main = 'if __name__ == "__main__":\n\t$0',
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
        ns      = 'namespace $1 {\n\t$0\n} // namespace $1',
        fwd     = 'std::forward<$1>($0)',
        mv      = 'std::move($1)',
        to      = 'std::ranges::to<${1:std::vector}>()',
        r       = 'std::ranges::',
        v       = 'std::views::',
        c       = 'std::chrono::',
        f       = 'std::filesystem::',
    },
    cmake = {
        ['for'] = 'foreach ($1)\n\t$0\nendforeach ()',
        ['if']  = 'if (${1:condition})\n\t$0\nendif ()',
        fn      = 'function (${1:function-name})\n\t$0\nendfunction ()',
    },
    gdscript = {
        fn = 'func ${1:function-name}($2) -> $3:\n\t${4:pass}',
    },
    javascript = {
        log = 'console.log($0)',
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
    text = {
        tst = '===\n$1\n===\n$0\n---\n\n(source_file)',
    },
}
