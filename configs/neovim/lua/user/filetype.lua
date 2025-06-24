vim.filetype.add({
    extension = {
        h = 'c',
        tex = 'tex',
        ki = 'kieli',
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

filetype({ 'c', 'cpp', 'rust', 'kieli' }, function ()
    vim.bo.commentstring = '// %s'
end)

filetype('asm', function ()
    vim.bo.commentstring = '# %s'
end)

filetype('ocaml', function ()
    vim.bo.commentstring = '(* %s *)'
    vim.keymap.set('ia', '//', '(* *)<left><left><left>')
end)

filetype('cpp', function ()
    vim.b.scratchcmd = { 'run-tests', 'out/debug' }
end)

filetype({ 'c', 'cpp' }, function ()
    vim.cmd([[call matchadd('Keyword', 'NOLINTBEGIN\|NOLINTEND\|NOLINTNEXTLINE\|NOLINT')]])
end)

filetype('python', function (buffer)
    vim.b.scratchcmd = { 'python', vim.fn.expand('#' .. buffer .. '%') }
end)

filetype({ 'haskell', 'ocaml' }, function ()
    vim.bo.tabstop = 2
    vim.cmd('setlocal matchpairs-=<:>')
end)

filetype('gdscript', function ()
    vim.bo.expandtab = false
end)

filetype('tex', function (buffer)
    vim.bo[buffer].makeprg = 'latexmk -pdf $*'
    vim.keymap.set('n', 'j', 'gj', { buffer = buffer })
    vim.keymap.set('n', 'k', 'gk', { buffer = buffer })
    vim.keymap.set('n', '0', 'g0', { buffer = buffer })
    vim.keymap.set('n', '$', 'g$', { buffer = buffer })
end)

filetype('markdown', function (buffer)
    vim.keymap.set('n', '<leader><leader>', '<cmd>silent !md-view %<cr>', { buffer = buffer })
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

filetype({ 'help', 'man' }, function (buffer)
    vim.keymap.set('n', 'J', '3<c-e>',        { buffer = buffer })
    vim.keymap.set('n', 'K', '3<c-y>',        { buffer = buffer })
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = buffer })
end)

-- Use shellcheck if shell-language-server is not available.
if vim.fn.executable('shell-language-server') == 0 then
    filetype('sh', function (buffer)
        vim.cmd('compiler shellcheck')
        vim.api.nvim_create_autocmd('BufWritePost', {
            command = 'silent make! %',
            buffer  = buffer,
            desc    = 'Keep shellcheck diagnostics up to date',
        })
    end)
end
