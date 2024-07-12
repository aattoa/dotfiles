---@type fun(command: string): string
local function cmd(command)
    return '<Cmd>' .. command .. '<CR>'
end

-- Leader by itself does nothing
vim.keymap.set({ 'n', 'x' }, '<Leader>', '<Nop>')

-- Toggle search case sensitivity
vim.keymap.set('n', '<Leader>i', cmd('set ignorecase!'))

-- Toggle line number visibility
vim.keymap.set('n', '<Leader>n', cmd('set number!') .. cmd('set relativenumber!'))

-- Handle URLs in current buffer
vim.keymap.set('n', '<Leader>u', cmd([[call system('handle-urls', bufnr())]]))

-- Open a terminal buffer in a new tab
vim.keymap.set('n', '<Leader>t', cmd('tab terminal'))

-- Easier normal mode from terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

-- Clear current search highlight
vim.keymap.set('n', '<Esc>', cmd('nohlsearch'))

-- Easier alternate file access
vim.keymap.set('n', 'M', '<C-^>')

-- Explore with Netrw
vim.keymap.set('n', '<Leader>e',     cmd('Explore'))
vim.keymap.set('n', '<Leader>E',     cmd('Sexplore'))
vim.keymap.set('n', '<Leader><C-e>', cmd('Texplore'))

-- Tab controls
vim.keymap.set('n', '<C-t>', cmd('tabnew'))
vim.keymap.set('n', '<C-q>', cmd('tabclose'))
vim.keymap.set('n', 'H',     cmd('tabprevious'))
vim.keymap.set('n', 'L',     cmd('tabnext'))
vim.keymap.set('n', '<C-h>', cmd('tabmove -1'))
vim.keymap.set('n', '<C-l>', cmd('tabmove +1'))

for i = 1, 9 do
    vim.keymap.set('n', '<Leader>' .. i, i .. 'gt')
end
vim.keymap.set('n', '<Leader>0', 'g<Tab>')

-- Quickfix controls
vim.keymap.set('n', '<Leader>d', cmd('copen') .. '<C-w>p')
vim.keymap.set('n', '<Leader>D', cmd('copen'))
vim.keymap.set('n', '<Leader>c', cmd('cclose') .. cmd('lclose'))
vim.keymap.set('n', '<C-j>',     cmd('lnext') .. 'zz')
vim.keymap.set('n', '<C-k>',     cmd('lprevious') .. 'zz')

-- Popup-menu controls
vim.keymap.set({ 'i', 'c' }, '<C-j>', '<C-n>')
vim.keymap.set({ 'i', 'c' }, '<C-k>', 'pumvisible() ? "<C-p>" : "<C-k>"', { expr = true })
vim.keymap.set({ 'i', 'c' }, '<C-c>', 'pumvisible() ? "<C-e>" : "<C-c>"', { expr = true })
vim.keymap.set('i',          '<CR>',  'pumvisible() ? "<C-y>" : "<CR>"',  { expr = true })

-- Move selected lines up and down
vim.keymap.set('x', '<C-k>', ':move \'<-2<CR>gv=gv', { silent = true })
vim.keymap.set('x', '<C-j>', ':move \'>+1<CR>gv=gv', { silent = true })

-- Resize windows
vim.keymap.set('n', '(', cmd('horizontal resize -1'))
vim.keymap.set('n', ')', cmd('horizontal resize +1'))
vim.keymap.set('n', '<', cmd('vertical resize -2'))
vim.keymap.set('n', '>', cmd('vertical resize +2'))

-- Stay in visual mode on indent/dedent
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Write and quit
vim.keymap.set('n', '<Leader>w', cmd('write'))
vim.keymap.set('n', '<Leader>q', cmd('quit'))
vim.keymap.set('n', '<Leader>Q', cmd('mksession!') .. cmd('quitall'))

-- Normal mode actions in insert mode
vim.keymap.set('i', '<C-e>', '<C-o><C-e>')
vim.keymap.set('i', '<C-y>', '<C-o><C-y>')
vim.keymap.set('i', '<C-z>', '<C-o>zz')

-- Do not save paragraph jumps to the jumplist
vim.keymap.set({ 'n', 'x' }, '{', cmd([[execute 'keepjumps normal! ' . v:count1 . '{zz']]))
vim.keymap.set({ 'n', 'x' }, '}', cmd([[execute 'keepjumps normal! ' . v:count1 . '}zz']]))

---@type fun(open: string, close: string): string
local function surround(open, close)
    return '<Esc>`>a' .. close .. '<Esc>`<i' .. open .. '<Esc>gv' .. string.rep('ol', 2 * open:len())
end

-- Surround selected text
vim.keymap.set('x', 's(',  surround('(', ')'))
vim.keymap.set('x', 's{',  surround('{', '}'))
vim.keymap.set('x', 's[',  surround('[', ']'))
vim.keymap.set('x', 's<',  surround('<', '>'))
vim.keymap.set('x', 's|',  surround('|', '|'))
vim.keymap.set('x', 's*',  surround('*', '*'))
vim.keymap.set('x', 's`',  surround('`', '`'))
vim.keymap.set('x', 's ',  surround(' ', ' '))
vim.keymap.set('x', 's"',  surround('"', '"'))
vim.keymap.set('x', 's\'', surround('\'', '\''))
vim.keymap.set('x', 's/',  surround('/*', '*/'))
vim.keymap.set('x', 'sa',  surround('assert(', ')'))

-- Unsurround selected text
vim.keymap.set('x', 'S', '<Esc>`>l"_x`<h"_xgvohoh')

-- Center the cursor after movements
for _, movement in ipairs({ 'G', 'n', 'N', '<C-d>', '<C-u>', '<C-o>', '<C-i>' }) do
    vim.keymap.set({ 'n', 'x' }, movement, movement .. 'zz')
end

-- Center the cursor after searching
vim.keymap.set('c', '<CR>', 'getcmdtype() =~ "[/?]" ? "<CR>zz" : "<CR>"', { expr = true })

-- Rotate alphabet
vim.keymap.set('i', '<C-a>', require('util.alphabet').rotate)

-- Snippet controls (expansion and completion keys defined in plugins.snippets)
vim.keymap.set({ 'i', 's' }, '<C-h>', function () vim.snippet.jump(-1) end)
vim.keymap.set('s',          '<C-l>', function () vim.snippet.jump(1) end)
