local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local util = require("config.snippets.util")

ls.add_snippets("cpp", {
    ls.snippet("for", fmt("for (std::size_t {} = {}; {} != {}; ++{}) {{\n\t{}\n}}", {
        ls.insert_node(1, "i"),
        ls.insert_node(2, "0"),
        util.reference_node(5, 1),
        ls.insert_node(3),
        util.reference_node(6, 1),
        ls.insert_node(4),
    })),
    ls.snippet("formatter", fmt([[template <{}>
struct std::formatter<{}> {{
    constexpr auto parse(auto& context) {{
        return context.begin();
    }}
    auto format({} const& {}, auto& context) const {{
        return std::format_to(context.out(), "{}");
    }}
}};]], {
        ls.insert_node(1),
        ls.insert_node(2),
        util.reference_node(5, 2),
        ls.insert_node(3),
        ls.insert_node(4),
    })),
})
