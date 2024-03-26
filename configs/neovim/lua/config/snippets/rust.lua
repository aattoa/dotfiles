local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("rust", {
    ls.snippet("derive", fmt("#[derive({})]", {
        ls.insert_node(1, "traits"),
    })),
    ls.snippet("test", fmt("#[test]\nfn {}() {{\n\t{}\n}}", {
        ls.insert_node(1, "test-name"),
        ls.insert_node(2),
    })),
    ls.snippet("tests", fmt("#[cfg(test)]\nmod tests {{\n\tuse super::*;\n\n\t{}\n}}", {
        ls.insert_node(1),
    })),
})
