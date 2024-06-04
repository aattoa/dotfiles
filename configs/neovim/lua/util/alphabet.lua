local M = {}

---@return Iter
local function characters()
    local chars = 'abcdefghijklmnopqrstuvwxyz'
    return vim.iter((chars .. chars:upper()):gmatch('.'))
end

M.greek = function ()
    characters():each(function (character)
        vim.keymap.set('i', character, '<C-k>*' .. character)
    end)
    vim.notify('Greek alphabet')
end

M.latin = function ()
    characters():each(function (character)
        vim.keymap.del('i', character)
    end)
    vim.notify('Latin alphabet')
end

M.current = 'latin'

M.rotate = function ()
    local rotations = { latin = 'greek', greek = 'latin' }
    M.current = rotations[M.current]
    M[M.current]()
end

return M
