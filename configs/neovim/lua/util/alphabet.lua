local M = {}

---@param callback fun(character: string): nil
local function for_each_character(callback)
    for character in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
        callback(character:upper())
        callback(character:lower())
    end
end

M.greek = function ()
    for_each_character(function (character)
        vim.keymap.set("i", character, "<C-k>*" .. character)
    end)
    vim.notify("Greek alphabet")
end

M.latin = function ()
    for_each_character(function (character)
        vim.keymap.del("i", character)
    end)
    vim.notify("Latin alphabet")
end

M.current = "latin"

M.rotate = function ()
    M.current = ({ greek = "latin", latin = "greek" })[M.current]
    M[M.current]()
end

return M
