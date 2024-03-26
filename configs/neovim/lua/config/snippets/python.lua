local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local util = require("config.snippets.util")

ls.add_snippets("python", {
    ls.snippet("main", fmt("def {}():\n\t{}\n\nif __name__ == \"__main__\":\n\t{}()", {
        ls.insert_node(1, "main"),
        ls.insert_node(2, "pass"),
        util.reference_node(3, 1),
    })),
})
