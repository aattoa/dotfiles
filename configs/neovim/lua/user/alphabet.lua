---@return Iter
local function characters()
    local chars = 'abcdefghijklmnopqrstuvwxyz'
    return vim.iter((chars .. chars:upper()):gmatch('.'))
end

local alphabets = {
    greek = function (character)
        vim.keymap.set('i', character, '<c-k>*' .. character)
    end,
    latin = function (character)
        vim.keymap.del('i', character)
    end,
}

local rotations = {
    latin = 'greek',
    greek = 'latin',
}

local current = 'latin'

local function rotate()
    current = rotations[current]
    characters():each(alphabets[current])
    vim.notify('Using alphabet: ' .. current)
end

vim.keymap.set('n', '<leader>a', rotate)
