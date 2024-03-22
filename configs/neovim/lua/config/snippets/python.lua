local ls = require("luasnip")
local util = require("config.snippets.util")

ls.add_snippets("python", {
    ls.snippet({
        trig = "main",
        dscr = "Module entry point",
    }, {
        ls.text_node("def "),
        ls.insert_node(1, "main"),
        ls.text_node({ "():", "\t" }),
        ls.insert_node(2, "pass"),
        ls.text_node({ "", "", "if __name__ == \"__main__\":", "\t" }),
        util.reference_node(3, 1),
        ls.text_node("()"),
        ls.insert_node(0),
    }),
})
