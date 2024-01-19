local ls = require("luasnip")
local util = require("config.snippets.util")

ls.add_snippets("cpp", {
    ls.snippet({
        trig = "for size_t",
        dscr = "Classic index-based for-loop",
    }, {
        ls.text_node("for (std::size_t "),
        ls.insert_node(1, "i"),
        ls.text_node(" = "),
        ls.insert_node(2, "0"),
        ls.text_node("; "),
        util.simple_dynamic_node(5, 1),
        ls.text_node(" != "),
        ls.insert_node(3),
        ls.text_node("; ++"),
        util.simple_dynamic_node(6, 1),
        ls.text_node({") {", "\t" }),
        ls.insert_node(4),
        ls.text_node({ "", "}" }),
        ls.insert_node(0),
    }),
})
