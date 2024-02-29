local ls = require("luasnip")
local util = require("config.snippets.util")

ls.add_snippets("cpp", {
    ls.snippet({
        trig = "for index",
        dscr = "Classic index-based for-loop",
    }, {
        ls.text_node("for (std::size_t "),
        ls.insert_node(1, "i"),
        ls.text_node(" = "),
        ls.insert_node(2, "0"),
        ls.text_node("; "),
        util.reference_node(5, 1),
        ls.text_node(" != "),
        ls.insert_node(3),
        ls.text_node("; ++"),
        util.reference_node(6, 1),
        ls.text_node({") {", "\t" }),
        ls.insert_node(4),
        ls.text_node({ "", "}" }),
        ls.insert_node(0),
    }),

    ls.snippet({
        trig = "formatter",
        dscr = "Specialize std::formatter",
    }, {
        ls.text_node("template <"),
        ls.insert_node(1),
        ls.text_node({ ">", "struct std::formatter<" }),
        ls.insert_node(2),
        ls.text_node({
            "> {",
            "\tconstexpr auto parse(auto& context) {",
            "\t\treturn context.begin();",
            "\t}",
            "\tauto format(",
        }),
        util.reference_node(5, 2),
        ls.text_node(" const& "),
        ls.insert_node(3),
        ls.text_node({
            ", auto& context) const {",
            "\t\treturn std::format_to(context.out(), \"",
        }),
        ls.insert_node(4),
        ls.text_node({ "\");", "\t}", "};" }),
        ls.insert_node(0),
    }),
})
