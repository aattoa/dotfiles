local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local util = require("config.snippets.util")

ls.add_snippets("markdown", {
    ls.snippet("link", fmt("[{}]({})", {
        ls.insert_node(1),
        util.reference_node(2, 1),
    })),
})
