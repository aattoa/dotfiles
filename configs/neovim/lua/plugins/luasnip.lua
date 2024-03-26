return {
    "L3MON4D3/LuaSnip",
    keys = {
        { "<C-j>", function () require("luasnip").expand_or_jump() end, mode = { "i", "s" } },
        { "<C-k>", function () require("luasnip").jump(-1) end,         mode = { "i", "s" } },
    },
    config = function ()
        require("luasnip").setup({
            update_events = { "TextChanged", "TextChangedI" },
        })
        require("config.snippets.cpp")
        require("config.snippets.rust")
        require("config.snippets.haskell")
        require("config.snippets.python")
        require("config.snippets.shell")
        require("config.snippets.markdown")
    end,
}
