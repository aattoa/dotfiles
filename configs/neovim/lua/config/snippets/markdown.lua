local ls = require("luasnip")
local util = require("config.snippets.util")

ls.add_snippets("markdown", {
    ls.snippet({
        trig = "link",
    }, {
        ls.text_node("["),
        ls.insert_node(1),
        ls.text_node("]("),
        util.reference_node(2, 1),
        ls.text_node(")"),
        ls.insert_node(0),
    }),

    ls.snippet({
        trig = "code",
    }, {
        ls.text_node("```"),
        ls.insert_node(1),
        ls.text_node( { "", "```" }),
        ls.insert_node(0),
    }),
})
