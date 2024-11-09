---@type fun(command: string): string
local function cmd(command)
    return '<cmd>' .. command .. '<cr>'
end

-- Leader by itself does nothing
vim.keymap.set({ 'n', 'x' }, '<leader>', '<nop>')

-- Toggle line number visibility
vim.keymap.set('n', '<leader>n', cmd('set number!') .. cmd('set relativenumber!'))

-- Handle URLs in current buffer
vim.keymap.set('n', '<leader>u', cmd([[call system('handle-urls', bufnr())]]))

-- Open a terminal buffer in a new tab
vim.keymap.set('n', '<leader>t', cmd('tab terminal'))

-- Clear current search highlight
vim.keymap.set('n', '<esc>', cmd('nohlsearch'))

-- Easier alternate file access
vim.keymap.set('n', 'M', '<c-^>')

-- Explore with Netrw
vim.keymap.set('n', '<leader>e',     cmd('Explore'))
vim.keymap.set('n', '<leader>E',     cmd('Vexplore'))
vim.keymap.set('n', '<leader><c-e>', cmd('Texplore'))

-- Buffer controls
vim.keymap.set('n', '<c-f>', cmd('bnext'))
vim.keymap.set('n', '<c-b>', cmd('bprevious'))

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
vim.keymap.set('n', '<leader>d', cmd('copen') .. '<c-w>p' .. cmd('lua vim.diagnostic.setqflist()'))
vim.keymap.set('n', '<leader>c', cmd('cclose') .. cmd('lclose'))
vim.keymap.set('n', '<c-j>',     cmd('cnext') .. 'zz')
vim.keymap.set('n', '<c-k>',     cmd('cprevious') .. 'zz')

-- Popup-menu controls
vim.keymap.set({ 'i', 'c' }, '<c-j>', '<c-n>')
vim.keymap.set({ 'i', 'c' }, '<c-k>', 'pumvisible() ? "<c-p>" : "<c-k>"', { expr = true })
vim.keymap.set('c',          '<c-c>', 'pumvisible() ? "<c-e>" : "<c-c>"', { expr = true })
vim.keymap.set('i',          '<c-c>', 'pumvisible() ? "<c-e>" : &omnifunc=="" ? "<c-x><c-n>" : "<c-x><c-o>"', { expr = true })
vim.keymap.set('i',          '<cr>',  'pumvisible() ? "<c-y>" : "<cr>"', { expr = true })

-- Move selected lines up and down
vim.keymap.set('x', '<c-k>', ':move \'<-2<cr>gv=gv', { silent = true })
vim.keymap.set('x', '<c-j>', ':move \'>+1<cr>gv=gv', { silent = true })

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

-- Yank file to system clipboard
vim.keymap.set('n', '<leader>y', [[m'gg"+yG''zz]])

-- Make file
vim.keymap.set('n', '<leader>m', cmd('make! %'))

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
vim.keymap.set('x', 's$', surround('$', '$'))
vim.keymap.set('x', 's-', surround('-', '-'))
vim.keymap.set('x', 's`', surround('`', '`'))
vim.keymap.set('x', 's ', surround(' ', ' '))
vim.keymap.set('x', 's"', surround('"', '"'))
vim.keymap.set('x', "s'", surround("'", "'"))
vim.keymap.set('x', 's/', surround('/*', '*/'))
vim.keymap.set('x', 'sa', surround('assert(', ')'))

-- Unsurround selected text
vim.keymap.set('x', 'S', '<esc>`>l"_x`<h"_xgvohoh')

-- Make it easier to hold down `[[` and `]]`
vim.keymap.set({ 'n', 'x' }, '[]', '<nop>')
vim.keymap.set({ 'n', 'x' }, '][', '<nop>')

-- Umlauts
vim.keymap.set({ 'i', 'c' }, '<c-a>', '<c-k>a:')
vim.keymap.set({ 'i', 'c' }, '<c-o>', '<c-k>o:')

-- Center the cursor after movements
for _, movement in ipairs({ 'G', 'n', 'N', 'g;', 'g,', '<c-d>', '<c-u>', '<c-o>', '<c-i>' }) do
    vim.keymap.set({ 'n', 'x' }, movement, movement .. 'zz')
end

-- Center the cursor after searching
vim.keymap.set('c', '<cr>', 'getcmdtype() =~ "[/?]" ? "<cr>zz" : "<cr>"', { expr = true })

local window_mode = false
vim.keymap.set('n', 'X', function ()
    window_mode = not window_mode
    if window_mode then
        vim.notify('Window mode')
        vim.keymap.set('n', 'h', cmd('vertical resize -2'))
        vim.keymap.set('n', 'l', cmd('vertical resize +2'))
        vim.keymap.set('n', 'j', cmd('horizontal resize -1'))
        vim.keymap.set('n', 'k', cmd('horizontal resize +1'))
    else
        vim.notify('Normal mode')
        vim.keymap.del('n', 'h')
        vim.keymap.del('n', 'l')
        vim.keymap.del('n', 'j')
        vim.keymap.del('n', 'k')
    end
end)
