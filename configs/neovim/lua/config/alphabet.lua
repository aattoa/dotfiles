local M = {}

---@param callback fun(character: string): nil
local function for_each_character(callback)
    for character in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
        callback(string.upper(character))
        callback(character)
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

---@type boolean
local is_latin = true

M.toggle = function ()
    if is_latin then M.greek() else M.latin() end
    is_latin = not is_latin
end

return M
