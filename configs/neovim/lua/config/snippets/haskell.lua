local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local util = require("config.snippets.util")

ls.add_snippets("haskell", {
    ls.snippet("def", fmt("{} :: {}\n{} = {}", {
        ls.insert_node(1, "name"),
        ls.insert_node(2, "type"),
        util.reference_node(4, 1),
        ls.insert_node(3, "undefined"),
    })),
})
