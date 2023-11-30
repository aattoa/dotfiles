local ls = require("luasnip")

ls.add_snippets("lua", {
    ls.snippet({
        trig = "lr",
        name = "Local require",
        dscr = "Require a lua library",
    }, {
        ls.text_node("local "),
        ls.insert_node(1, "variable-name"),
        ls.text_node(" = require(\""),
        ls.insert_node(2, "library-name"),
        ls.text_node("\")"),
        ls.insert_node(0),
    }),
})

