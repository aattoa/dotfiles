-- n: normal
-- i: insert
-- v: visual
-- x: visual block
-- t: terminal
-- c: command

---@param command string
local function cmd(command)
    return "<Cmd>" .. command .. "<Return>"
end

-- Explore with Netrw
vim.keymap.set("n", "<Leader>e",     cmd("Explore"))
vim.keymap.set("n", "<Leader>E",     cmd("Sexplore"))
vim.keymap.set("n", "<Leader><C-e>", cmd("Texplore"))

-- Extract URLs from current buffer
vim.keymap.set("n", "<Leader>u", cmd("call system(\"handle-urls\", join(getline(1, '$'), \"\\n\") .. \"\\n\")"))

-- Toggle search case sensitivity
vim.keymap.set("n", "<Leader>i", cmd("set ignorecase!"))

-- Toggle search highlight
vim.keymap.set("n", "<Leader>h", cmd("set hlsearch!"))

-- Toggle line number visibility
vim.keymap.set("n", "<Leader>n", cmd("set number!") .. cmd("set relativenumber!"))

-- Jumplist navigation (necessary because <C-i> conflicts with <Tab>)
vim.keymap.set("n", "<Leader>j", "<C-o>zz")
vim.keymap.set("n", "<Leader>k", "<C-i>zz")

-- Toggle between alphabets
vim.keymap.set("n", "<Leader>a", ALPHABET_TOGGLE)
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
vim.keymap.set("n", "<C-t>",   cmd("tabnew"))
vim.keymap.set("n", "<C-q>",   cmd("tabclose"))
vim.keymap.set("n", "<Tab>",   cmd("tabnext"))
vim.keymap.set("n", "<S-Tab>", cmd("tabprevious"))
vim.keymap.set("n", "g<",      cmd("tabmove -1"))
vim.keymap.set("n", "g>",      cmd("tabmove +1"))

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<C-k>", ":move .-2<Return>==",     { silent = true }) -- Current line up
vim.keymap.set("n", "<C-j>", ":move .+1<Return>==",     { silent = true }) -- Current line down
vim.keymap.set("v", "<C-k>", ":move '<-2<Return>gv=gv", { silent = true }) -- Selected lines up
vim.keymap.set("v", "<C-j>", ":move '>+1<Return>gv=gv", { silent = true }) -- Selected lines down

-- Window resizing
vim.keymap.set("n", "<C-M-j>", cmd("resize -1"))
vim.keymap.set("n", "<C-M-k>", cmd("resize +1"))
vim.keymap.set("n", "<C-M-h>", cmd("vertical resize -2"))
vim.keymap.set("n", "<C-M-l>", cmd("vertical resize +2"))

-- Stay in visual mode on indent/dedent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Make current file
vim.keymap.set("n", "<Leader>m", cmd("silent make"))

-- Emulate normal mode navigation in command mode
vim.keymap.set("c", "<C-b>", "<S-Left>")
vim.keymap.set("c", "<C-w>", "<S-Right>")
vim.keymap.set("c", "<C-h>", "<Left>")
vim.keymap.set("c", "<C-j>", "<Down>")
vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-l>", "<Right>")

-- Center the cursor after movements
for _, movement in ipairs { "G", "n", "N", "<C-d>", "<C-u>", "{", "}" } do
    vim.keymap.set({ "n", "v" }, movement, movement .. "zz")
end