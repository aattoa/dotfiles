local ls = require("luasnip")

ls.add_snippets("rust", {
    ls.snippet({
        trig = "derive",
        dscr = "Derive traits",
    }, {
        ls.text_node("#[derive("),
        ls.insert_node(1, "traits"),
        ls.text_node(")]"),
        ls.insert_node(0),
    }),

    ls.snippet({
        trig = "test",
        dscr = "Unit test",
    }, {
        ls.text_node({ "#[test]", "fn " }),
        ls.insert_node(1, "test-name"),
        ls.text_node({ "() {", "\t" }),
        ls.insert_node(2),
        ls.text_node({ "", "}" }),
        ls.insert_node(0),
    }),

    ls.snippet({
        trig = "tests",
        dscr = "Test module",
    }, {
        ls.text_node({ "#[cfg(test)]", "mod tests {", "\tuse super::*;", "", "\t" }),
        ls.insert_node(1),
        ls.text_node({ "", "}" }),
        ls.insert_node(0),
    }),
})
