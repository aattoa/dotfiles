local ls = require("luasnip")
local util = require("config.snippets.util")

ls.add_snippets("haskell", {
    ls.snippet({
        trig = "def",
        dscr = "Top level definition",
    }, {
        ls.insert_node(1, "name"),
        ls.text_node(" :: "),
        ls.insert_node(2, "type"),
        ls.text_node({ "", "" }),
        util.reference_node(4, 1),
        ls.text_node(" = "),
        ls.insert_node(3, "undefined"),
        ls.insert_node(0),
    }),
})
