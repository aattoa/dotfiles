vim.filetype.add({
    extension = {
        h = 'c',
        jsx = 'javascript',
        tex = 'tex',
        kieli = 'kieli',
    },
    filename = {
        xinitrc = 'sh',
        ['.env'] = 'text',
        ['poetry.lock'] = 'toml',
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

filetype({ 'help', 'man' }, function (buffer)
    vim.keymap.set('n', 'J', '3<c-e>',        { buffer = buffer })
    vim.keymap.set('n', 'K', '3<c-y>',        { buffer = buffer })
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = buffer })
end)

filetype('sh', function (buffer)
    vim.cmd('compiler shellcheck')
    vim.api.nvim_create_autocmd('BufWritePost', {
        command = 'silent make! %',
        buffer  = buffer,
        desc    = 'Keep shellcheck diagnostics up to date',
    })
end)

filetype({ 'c', 'cpp', 'rust', 'kieli' }, function (buffer)
    vim.bo[buffer].commentstring = '// %s'
end)

filetype('cpp', function (buffer)
    vim.b[buffer].scratchcmd = { 'run-tests', 'out/debug' }
end)

filetype('python', function (buffer)
    vim.b[buffer].scratchcmd = { 'python', vim.fn.expand('#' .. buffer .. '%') }
end)

filetype('javascript', function (buffer)
    vim.bo[buffer].omnifunc = ''
end)

filetype({ 'haskell', 'ocaml', 'javascript' }, function (buffer)
    vim.bo[buffer].tabstop = 2
end)

filetype('gdscript', function (buffer)
    vim.bo[buffer].expandtab = false
end)

filetype('tex', function (buffer)
    vim.bo[buffer].makeprg = 'latexmk -pdf $*'
    vim.keymap.set('n', 'j', 'gj', { buffer = buffer })
    vim.keymap.set('n', 'k', 'gk', { buffer = buffer })
    vim.keymap.set('n', '0', 'g0', { buffer = buffer })
    vim.keymap.set('n', '$', 'g$', { buffer = buffer })
end)

filetype('query', function (buffer)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = buffer })
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
