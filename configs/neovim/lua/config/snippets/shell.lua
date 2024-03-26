local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("sh", {
    ls.snippet("err", fmt("echo \"{}\" 1>&2", {
        ls.insert_node(1),
    })),
    ls.snippet("case", fmt("case {} in\n\t{})\n\t\t{};;\n\t*)\n\t\t{};;\nesac", {
        ls.insert_node(1),
        ls.insert_node(2),
        ls.insert_node(3),
        ls.insert_node(4),
    })),
    ls.snippet("fn", fmt("{} () {{\n\t{}\n}}", {
        ls.insert_node(1, "function-name"),
        ls.insert_node(2),
    })),
})
