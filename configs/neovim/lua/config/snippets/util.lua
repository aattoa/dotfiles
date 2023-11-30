local M = {}

---@param jump_index integer
---@param reference_index integer
M.simple_dynamic_node = function (jump_index, reference_index)
    local ls = require("luasnip")
    return ls.dynamic_node(jump_index, function (args)
        return ls.snippet_node(nil, { ls.insert_node(1, args[1]) })
    end, { reference_index })
end

return M
