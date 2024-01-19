local ls = require("luasnip")

ls.add_snippets("sh", {
    ls.snippet({
        trig = "echo-err",
        dscr = "Echo to stderr",
    }, {
        ls.text_node("echo \""),
        ls.insert_node(1),
        ls.text_node("\" 1>&2"),
        ls.insert_node(0),
    }),
    ls.snippet({
        trig = "case",
        dscr = "Case statement",
    }, {
        ls.text_node("case \"$("),
        ls.insert_node(1, "command"),
        ls.text_node({ ")\" in", "\t\"" }),
        ls.insert_node(2),
        ls.text_node({ "\")", "\t\t" }),
        ls.insert_node(3, "echo"),
        ls.text_node({ ";;", "\t*)", "\t\t" }),
        ls.insert_node(4, "echo"),
        ls.text_node({ ";;", "esac" }),
        ls.insert_node(0),
    }),
})
