---@type fun(command: string): string
local function cmd(command)
    return '<cmd>' .. command .. '<cr>'
end

-- Leader by itself does nothing
vim.keymap.set({ 'n', 'x' }, '<leader>', '<nop>')

-- Toggle search case sensitivity
vim.keymap.set('n', '<leader>i', cmd('set ignorecase!'))

-- Toggle line number visibility
vim.keymap.set('n', '<leader>n', cmd('set number!') .. cmd('set relativenumber!'))

-- Handle URLs in current buffer
vim.keymap.set('n', '<leader>u', cmd([[call system('handle-urls', bufnr())]]))

-- Open a terminal buffer in a new tab
vim.keymap.set('n', '<leader>t', cmd('tab terminal'))

-- Easier normal mode from terminal mode
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

-- Clear current search highlight
vim.keymap.set('n', '<esc>', cmd('nohlsearch'))

-- Easier alternate file access
vim.keymap.set('n', 'M', '<c-^>')

-- Explore with Netrw
vim.keymap.set('n', '<leader>e',     cmd('Explore'))
vim.keymap.set('n', '<leader>E',     cmd('Sexplore'))
vim.keymap.set('n', '<leader><c-e>', cmd('Texplore'))

-- Tab controls
vim.keymap.set('n', '<c-t>', cmd('tabnew'))
vim.keymap.set('n', '<c-q>', cmd('tabclose'))
vim.keymap.set('n', 'H',     cmd('tabprevious'))
vim.keymap.set('n', 'L',     cmd('tabnext'))
vim.keymap.set('n', '<c-h>', cmd('tabmove -1'))
vim.keymap.set('n', '<c-l>', cmd('tabmove +1'))

for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, i .. 'gt')
end
vim.keymap.set('n', '<leader>0', 'g<tab>')

-- Quickfix controls
vim.keymap.set('n', '<leader>d', cmd('copen') .. '<c-w>p')
vim.keymap.set('n', '<leader>D', cmd('copen'))
vim.keymap.set('n', '<leader>c', cmd('cclose') .. cmd('lclose'))
vim.keymap.set('n', '<c-j>',     cmd('lnext') .. 'zz')
vim.keymap.set('n', '<c-k>',     cmd('lprevious') .. 'zz')

-- Popup-menu controls
vim.keymap.set({ 'i', 'c' }, '<c-j>', '<c-n>')
vim.keymap.set({ 'i', 'c' }, '<c-k>', 'pumvisible() ? "<c-p>" : "<c-k>"', { expr = true })
vim.keymap.set({ 'i', 'c' }, '<c-c>', 'pumvisible() ? "<c-e>" : "<c-c>"', { expr = true })
vim.keymap.set('i',          '<cr>',  'pumvisible() ? "<c-y>" : "<cr>"',  { expr = true })

-- Move selected lines up and down
vim.keymap.set('x', '<c-k>', ':move \'<-2<cr>gv=gv', { silent = true })
vim.keymap.set('x', '<c-j>', ':move \'>+1<cr>gv=gv', { silent = true })

-- Resize windows
vim.keymap.set('n', '(', cmd('horizontal resize -1'))
vim.keymap.set('n', ')', cmd('horizontal resize +1'))
vim.keymap.set('n', '<', cmd('vertical resize -2'))
vim.keymap.set('n', '>', cmd('vertical resize +2'))

-- Stay in visual mode on indent/dedent
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Write and quit
vim.keymap.set('n', '<leader>w', cmd('write'))
vim.keymap.set('n', '<leader>q', cmd('quit'))
vim.keymap.set('n', '<leader>Q', cmd('mksession!') .. cmd('quitall'))

-- Normal mode actions in insert mode
vim.keymap.set('i', '<c-e>', '<c-o><c-e>')
vim.keymap.set('i', '<c-y>', '<c-o><c-y>')
vim.keymap.set('i', '<c-z>', '<c-o>zz')

-- Do not save paragraph jumps to the jumplist
vim.keymap.set({ 'n', 'x' }, '{', cmd([[execute 'keepjumps normal! ' . v:count1 . '{zz']]))
vim.keymap.set({ 'n', 'x' }, '}', cmd([[execute 'keepjumps normal! ' . v:count1 . '}zz']]))

---@type fun(open: string, close: string): string
local function surround(open, close)
    return '<esc>`>a' .. close .. '<esc>`<i' .. open .. '<esc>gv' .. string.rep('ol', 2 * open:len())
end

-- Surround selected text
vim.keymap.set('x', 's(', surround('(', ')'))
vim.keymap.set('x', 's{', surround('{', '}'))
vim.keymap.set('x', 's[', surround('[', ']'))
vim.keymap.set('x', 's<', surround('<', '>'))
vim.keymap.set('x', 's|', surround('|', '|'))
vim.keymap.set('x', 's*', surround('*', '*'))
vim.keymap.set('x', 's`', surround('`', '`'))
vim.keymap.set('x', 's ', surround(' ', ' '))
vim.keymap.set('x', 's"', surround('"', '"'))
vim.keymap.set('x', "s'", surround("'", "'"))
vim.keymap.set('x', 's/', surround('/*', '*/'))
vim.keymap.set('x', 'sa', surround('assert(', ')'))

-- Unsurround selected text
vim.keymap.set('x', 'S', '<esc>`>l"_x`<h"_xgvohoh')

-- Center the cursor after movements
for _, movement in ipairs({ 'G', 'n', 'N', '<c-d>', '<c-u>', '<c-o>', '<c-i>' }) do
    vim.keymap.set({ 'n', 'x' }, movement, movement .. 'zz')
end

-- Center the cursor after searching
vim.keymap.set('c', '<cr>', 'getcmdtype() =~ "[/?]" ? "<cr>zz" : "<cr>"', { expr = true })

-- Snippet controls (expansion and completion keys defined in plugins.snippets)
vim.keymap.set({ 'i', 's' }, '<c-h>', function () vim.snippet.jump(-1) end)
vim.keymap.set('s',          '<c-l>', function () vim.snippet.jump(1) end)
