local ls = require("luasnip")
local util = require("config.snippets.util")

---@param trigger string
---@param description string
---@param headers table
local function make_include_snippet(trigger, description, headers)
    for index, header in ipairs(headers) do
        if header:len() ~= 0 then
            headers[index] = "#include <" .. header .. ">"
        end
    end
    return ls.snippet({
        trig = "include_" .. trigger,
        dscr = "Headers containing " .. description,
    }, {
        ls.text_node(headers),
        ls.text_node({ "", "" }),
        ls.insert_node(0),
    })
end

ls.add_snippets("cpp", {
    ls.snippet({
        trig = "fn",
        name = "Function",
        dscr = "Function definition",
    }, {
        ls.text_node("[[nodiscard]] auto "),
        ls.insert_node(1, "function-name"),
        ls.text_node("("),
        ls.insert_node(2),
        ls.text_node(") -> "),
        ls.insert_node(3),
        ls.text_node({ " {", "\t" }),
        ls.insert_node(4),
        ls.text_node({ "", "}" }),
        ls.insert_node(0),
    }),

    ls.snippet({
        trig = "for size_t",
        dscr = "Classic index-based for-loop",
    }, {
        ls.text_node("for (std::size_t "),
        ls.insert_node(1, "i"),
        ls.text_node(" = "),
        ls.insert_node(2, "0"),
        ls.text_node("; "),
        util.simple_dynamic_node(5, 1),
        ls.text_node(" != "),
        ls.insert_node(3),
        ls.text_node("; ++"),
        util.simple_dynamic_node(6, 1),
        ls.text_node({") {", "\t" }),
        ls.insert_node(4),
        ls.text_node({ "", "}" }),
        ls.insert_node(0),
    }),

    make_include_snippet("basics", "basic utilities", {
        "cstddef",
        "cstdlib",
        "cstdint",
        "cassert",
        "",
        "vector",
        "utility",
        "compare",
        "optional",
        "concepts",
        "type_traits",
    }),

    make_include_snippet("strings", "string utilities", {
        "format",
        "string",
        "string_view",
    }),

    make_include_snippet("algos", "standard algorithms", {
        "ranges",
        "numeric",
        "algorithm",
        "functional",
    }),
})
