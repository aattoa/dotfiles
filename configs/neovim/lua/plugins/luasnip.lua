---@type fun(jump_index: integer, reference_index: integer): nil
local function reference_node(jump_index, reference_index)
    local ls = require("luasnip")
    return ls.dynamic_node(jump_index, function (args)
        return ls.snippet_node(nil, { ls.insert_node(1, args[1]) })
    end, { reference_index })
end

local function custom_snippets()
    local ls = require("luasnip")
    local format = require("luasnip.extras.fmt").fmt
    local repeat_node = require("luasnip.extras").rep
    return {
        all = {
            ls.snippet("date", {
                ls.function_node(function () return os.date("%F") end),
            }),
            ls.snippet("time", {
                ls.function_node(function () return os.date("%T") end),
            }),
        },
        haskell = {
            ls.snippet("fn", format("{} :: {}\n{} = {}", {
                ls.insert_node(1, "name"),
                ls.insert_node(2, "type"),
                repeat_node(1),
                ls.insert_node(3, "undefined"),
            })),
        },
        python = {
            ls.snippet("main", format("def {}():\n\t{}\n\nif __name__ == \"__main__\":\n\t{}()", {
                ls.insert_node(1, "main"),
                ls.insert_node(2, "pass"),
                repeat_node(1),
            })),
        },
        rust = {
            ls.snippet("derive", format("#[derive({})]", {
                ls.insert_node(1, "Debug"),
            })),
            ls.snippet("test", format("#[test]\nfn {}() {{\n\t{}\n}}", {
                ls.insert_node(1, "test-name"),
                ls.insert_node(2),
            })),
            ls.snippet("tests", format("#[cfg(test)]\nmod tests {{\n\tuse super::*;\n\n\t{}\n}}", {
                ls.insert_node(1),
            })),
        },
        cpp = {
            ls.snippet("for", format("for (std::size_t {} = {}; {} != {}; ++{}) {{\n\t{}\n}}", {
                ls.insert_node(1, "i"),
                ls.insert_node(2, "0"),
                repeat_node(1),
                ls.insert_node(3),
                repeat_node(1),
                ls.insert_node(4),
            })),
            ls.snippet("formatter", format(
[[template <{}>
struct std::formatter<{}> {{
    static constexpr auto parse(auto& context) {{
        return context.begin();
    }}
    static auto format({} const& {}, auto& context) const {{
        return std::format_to(context.out(), "{}", {});
    }}
}};]], {
                ls.insert_node(1),
                ls.insert_node(2),
                repeat_node(2),
                ls.insert_node(3),
                ls.insert_node(4),
                ls.insert_node(5),
            })),
            ls.snippet("fn", format("auto {}({}) -> {} {{\n\t{}\n}}", {
                ls.insert_node(1, "function-name"),
                ls.insert_node(2),
                ls.insert_node(3),
                ls.insert_node(4),
            })),
            ls.snippet("mv", format("std::move({})", {
                ls.insert_node(1),
            })),
            ls.snippet("to", format("std::ranges::to<{}>()", {
                ls.insert_node(1, "std::vector"),
            })),
        },
        sh = {
            ls.snippet("err", format("echo \"{}\" 1>&2", {
                ls.insert_node(1),
            })),
            ls.snippet("case", format("case {} in\n\t{})\n\t\t{};;\n\t*)\n\t\t{};;\nesac", {
                ls.insert_node(1),
                ls.insert_node(2),
                ls.insert_node(3),
                ls.insert_node(4),
            })),
            ls.snippet("fn", format("{} () {{\n\t{}\n}}", {
                ls.insert_node(1, "function-name"),
                ls.insert_node(2),
            })),
            ls.snippet("if", format("if {}; then\n\t{}\nfi", {
                ls.insert_node(1),
                ls.insert_node(2),
            })),
        },
        markdown = {
            ls.snippet("link", format("[{}]({})", {
                ls.insert_node(1),
                reference_node(2, 1),
            })),
        },
    }
end

return {
    -- TODO: neovim 0.10: Use vim.snippet
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
