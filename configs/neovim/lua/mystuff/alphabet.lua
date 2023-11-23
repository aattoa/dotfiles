---@param callback function
local function for_each_character (callback)
    for character in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
        callback(string.upper(character))
        callback(character)
    end
end

function ALPHABET_GREEK ()
    for_each_character (function (character)
        vim.keymap.set("i", character, "<C-k>*" .. character)
    end)
    print("Greek alphabet")
end

function ALPHABET_LATIN ()
    for_each_character (function (character)
        vim.keymap.del("i", character)
    end)
    print("Latin alphabet")
end

---@type boolean
local is_latin = true

function ALPHABET_TOGGLE ()
    if is_latin then
        ALPHABET_GREEK()
    else
        ALPHABET_LATIN()
    end
    is_latin = not is_latin
end
