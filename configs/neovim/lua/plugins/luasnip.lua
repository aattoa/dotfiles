---@param keys string
---@param index integer
local function map_jump(keys, index)
    vim.keymap.set({ "i", "s" }, keys, function ()
        local snip = require("luasnip")
        if snip.jumpable(index) then snip.jump(index) end
    end)
end

return {
    "L3MON4D3/LuaSnip",
    config = function ()
        map_jump("<C-j>",  1)
        map_jump("<C-k>", -1)
        require("luasnip").setup {
            update_events = { "TextChanged", "TextChangedI" },
        }
        require("config.snippets")
    end,
}
