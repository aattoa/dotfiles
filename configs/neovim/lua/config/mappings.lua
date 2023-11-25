-- n: normal
-- i: insert
-- v: visual
-- x: visual block
-- t: terminal
-- c: command

-- Explore with Netrw
vim.keymap.set("n", "<Leader>e", vim.cmd.Explore)

-- Extract URLs from current buffer
vim.keymap.set("n", "<Leader>u", "<Cmd>call system(\"handle-urls\", join(getline(1, '$'), \"\\n\") .. \"\\n\")<Return>")

-- Toggle search case sensitivity
vim.keymap.set("n", "<Leader>i", "<Cmd>set ignorecase!<Return>")

-- Toggle search highlight
vim.keymap.set("n", "<Leader>h", "<Cmd>set hlsearch!<Return>")

-- Toggle line number visibility
vim.keymap.set("n", "<Leader>n", "<Cmd>set number!<Return><Cmd>set relativenumber!<Return>")

-- Toggle between alphabets
vim.keymap.set("n", "<Leader>k", ALPHABET_TOGGLE)
vim.keymap.set("i", "<C-a>",     ALPHABET_TOGGLE)

-- System clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", "\"+")

-- Search and replace
vim.keymap.set("n", "<C-s>", ":%substitute//g<Left><Left>")
vim.keymap.set("v", "<C-s>", ":substitute//g<Left><Left>")

-- Count search results
vim.keymap.set("n", "<C-n>", ":%substitute///gn<Left><Left><Left><Left>")
vim.keymap.set("v", "<C-n>", ":substitute///gn<Left><Left><Left><Left>")

-- Tab controls
vim.keymap.set("n", "<C-t>",   vim.cmd.tabnew)
vim.keymap.set("n", "<C-q>",   vim.cmd.tabclose)
vim.keymap.set("n", "<Tab>",   vim.cmd.tabnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.tabprevious)
vim.keymap.set("n", "g<",      "<Cmd>tabmove -1<Return>")
vim.keymap.set("n", "g>",      "<Cmd>tabmove +1<Return>")

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<C-k>", ":move .-2<Return>==",     { silent = true }) -- Current line up
vim.keymap.set("n", "<C-j>", ":move .+1<Return>==",     { silent = true }) -- Current line down
vim.keymap.set("v", "<C-k>", ":move '<-2<Return>gv=gv", { silent = true }) -- Selected lines up
vim.keymap.set("v", "<C-j>", ":move '>+1<Return>gv=gv", { silent = true }) -- Selected lines down

-- Window resizing
vim.keymap.set("n", "<C-M-j>", "<Cmd>resize -1<Return>")
vim.keymap.set("n", "<C-M-k>", "<Cmd>resize +1<Return>")
vim.keymap.set("n", "<C-M-h>", "<Cmd>vertical resize -2<Return>")
vim.keymap.set("n", "<C-M-l>", "<Cmd>vertical resize +2<Return>")

-- Stay in visual mode on indent/dedent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Make current file
vim.keymap.set("n", "<Leader>a", "<Cmd>silent make<Return>")

-- Emulate normal mode navigation in command mode
vim.keymap.set("c", "<C-b>", "<S-Left>")
vim.keymap.set("c", "<C-w>", "<S-Right>")
vim.keymap.set("c", "<C-h>", "<Left>")
vim.keymap.set("c", "<C-j>", "<Down>")
vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-l>", "<Right>")

-- Center the cursor after movements
for _, movement in ipairs({ "G", "n", "N", "<C-d>", "<C-u>", "{", "}" }) do
    vim.keymap.set({ "n", "v" }, movement, movement .. "zz")
end
