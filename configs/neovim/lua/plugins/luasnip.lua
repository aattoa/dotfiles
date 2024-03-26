---@param jump_index integer
---@param reference_index integer
local function reference_node(jump_index, reference_index)
    local ls = require("luasnip")
    return ls.dynamic_node(jump_index, function (args)
        return ls.snippet_node(nil, { ls.insert_node(1, args[1]) })
    end, { reference_index })
end

local function custom_snippets()
    local ls  = require("luasnip")
    local fmt = require("luasnip.extras.fmt").fmt
    return {
        haskell = {
            ls.snippet("def", fmt("{} :: {}\n{} = {}", {
                ls.insert_node(1, "name"),
                ls.insert_node(2, "type"),
                reference_node(4, 1),
                ls.insert_node(3, "undefined"),
            })),
        },
        python = {
            ls.snippet("main", fmt("def {}():\n\t{}\n\nif __name__ == \"__main__\":\n\t{}()", {
                ls.insert_node(1, "main"),
                ls.insert_node(2, "pass"),
                reference_node(3, 1),
            })),
        },
        rust = {
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
        },
        cpp = {
            ls.snippet("for", fmt("for (std::size_t {} = {}; {} != {}; ++{}) {{\n\t{}\n}}", {
                ls.insert_node(1, "i"),
                ls.insert_node(2, "0"),
                reference_node(5, 1),
                ls.insert_node(3),
                reference_node(6, 1),
                ls.insert_node(4),
            })),
            ls.snippet("formatter", fmt(
[[template <{}>
struct std::formatter<{}> {{
    constexpr auto parse(auto& context) {{
        return context.begin();
    }}
    auto format({} const& {}, auto& context) const {{
        return std::format_to(context.out(), "{}");
    }}
}};]], {
                ls.insert_node(1),
                ls.insert_node(2),
                reference_node(5, 2),
                ls.insert_node(3),
                ls.insert_node(4),
            })),
        },
        sh = {
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
        },
        markdown = {
            ls.snippet("link", fmt("[{}]({})", {
                ls.insert_node(1),
                reference_node(2, 1),
            })),
        },
    }
end

return {
    "L3MON4D3/LuaSnip",
    keys = {
        { "<C-j>", function () require("luasnip").expand_or_jump() end, mode = { "i", "s" } },
        { "<C-k>", function () require("luasnip").jump(-1) end,         mode = { "i", "s" } },
    },
    config = function ()
        local ls = require("luasnip")
        ls.setup({
            update_events = { "TextChanged", "TextChangedI" },
        })
        for filetype, snippets in pairs(custom_snippets()) do
            ls.add_snippets(filetype, snippets)
        end
    end,
}
