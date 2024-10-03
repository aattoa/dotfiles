vim.filetype.add({
    extension = {
        h = 'c',
        tex = 'tex',
        kieli = 'kieli',
    },
    filename = {
        xinitrc = 'sh',
    },
})

---@param filetypes string[]|string
---@param callback fun(buffer: integer): nil
local function filetype(filetypes, callback)
    vim.api.nvim_create_autocmd('FileType', {
        pattern  = filetypes,
        callback = function (event) callback(event.buf) end,
        desc     = 'Set local options for ' .. vim.inspect(filetypes),
    })
end

---@param buffer integer
---@param description string
local function enable_auto_make(buffer, description)
    vim.api.nvim_create_autocmd('BufWritePost', {
        command = 'silent make! %',
        buffer  = buffer,
        desc    = description,
    })
end

filetype({ 'help', 'man' }, function (buffer)
    vim.keymap.set('n', 'J', '3<c-e>',        { buffer = buffer })
    vim.keymap.set('n', 'K', '3<c-y>',        { buffer = buffer })
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = buffer })
end)

filetype('sh', function (buffer)
    vim.cmd('compiler shellcheck')
    enable_auto_make(buffer, 'Keep shellcheck diagnostics up to date')
end)

filetype({ 'c', 'cpp', 'rust', 'kieli' }, function (buffer)
    vim.bo[buffer].commentstring = '// %s'
end)

filetype('haskell', function (buffer)
    vim.bo[buffer].tabstop = 2
end)

filetype('gdscript', function (buffer)
    vim.bo[buffer].expandtab = false
end)

filetype('tex', function (buffer)
    vim.bo[buffer].makeprg = 'latexmk -pdf $*'
end)

filetype('qf', function (buffer)
    vim.api.nvim_create_autocmd('WinEnter', {
        command = 'if winnr("$") == 1 | quit | endif',
        buffer  = buffer,
        desc    = 'Close dangling quickfix window',
    })
    vim.keymap.set('n', 'r', vim.diagnostic.setqflist, { buffer = buffer })
    vim.keymap.set('n', 'J', 'j<cr>zz<c-w>p', { buffer = buffer })
    vim.keymap.set('n', 'K', 'k<cr>zz<c-w>p', { buffer = buffer })
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = buffer })
end)

filetype('fzf', function (buffer)
    vim.keymap.set('t', '<esc>', '<esc>', {
        nowait = true,
        buffer = buffer,
        desc   = 'Hide global terminal mode mapping <esc><esc>',
    })
end)
