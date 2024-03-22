return {
    "L3MON4D3/LuaSnip",
    config = function ()
        local ls = require("luasnip")
        ls.setup({ update_events = { "TextChanged", "TextChangedI" } })

        vim.keymap.set({ "i", "s" }, "<C-j>", ls.expand_or_jump)
        vim.keymap.set({ "i", "s" }, "<C-k>", function () ls.jump(-1) end)

        require("config.snippets.cpp")
        require("config.snippets.rust")
        require("config.snippets.haskell")
        require("config.snippets.python")
        require("config.snippets.shell")
        require("config.snippets.markdown")
    end,
    event = "InsertEnter",
}
