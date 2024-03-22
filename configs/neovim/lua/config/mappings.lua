---@param command string
---@return string
local function cmd(command)
    return "<Cmd>" .. command .. "<Return>"
end

-- Leader by itself does nothing
vim.keymap.set({ "n", "v" }, "<Leader>", "<Nop>")

-- Toggle search case sensitivity
vim.keymap.set("n", "<Leader>i", cmd("set ignorecase!"))

-- Toggle search highlight
vim.keymap.set("n", "<Leader>h", cmd("set hlsearch!"))

-- Clear current search highlight
vim.keymap.set("n", "<Esc>", cmd("nohlsearch"))

-- Toggle line number visibility
vim.keymap.set("n", "<Leader>n", cmd("set number!") .. cmd("set relativenumber!"))

-- Handle URLs in current buffer
vim.keymap.set("n", "<Leader>u", cmd("call system('handle-urls', bufnr())"))

-- Jumplist navigation (necessary because <C-i> conflicts with <Tab>)
vim.keymap.set("n", "<Leader>j", "<C-o>zz")
vim.keymap.set("n", "<Leader>k", "<C-i>zz")

-- Toggle between alphabets
vim.keymap.set("i", "<C-a>", require("config.alphabet").toggle)

-- Easier alternate file access
vim.keymap.set("n", "L", "<C-^>")

-- System clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", "\"+")

-- Search and replace
vim.keymap.set("n", "<C-s>", ":%substitute//g<Left><Left>")
vim.keymap.set("v", "<C-s>", ":substitute//g<Left><Left>")

-- Explore with Netrw
vim.keymap.set("n", "<Leader>e",     cmd("Explore"))
vim.keymap.set("n", "<Leader>E",     cmd("Sexplore"))
vim.keymap.set("n", "<Leader><C-e>", cmd("Texplore"))

-- Tab controls
vim.keymap.set("n", "<C-t>",   cmd("tabnew"))
vim.keymap.set("n", "<C-q>",   cmd("tabclose"))
vim.keymap.set("n", "<Tab>",   cmd("tabnext"))
vim.keymap.set("n", "<S-Tab>", cmd("tabprevious"))
vim.keymap.set("n", "g<",      cmd("tabmove -1"))
vim.keymap.set("n", "g>",      cmd("tabmove +1"))

for i = 1, 9 do
    vim.keymap.set("n", "<Leader>" .. i, i .. "gt")
end
vim.keymap.set("n", "<Leader>0", "g<Tab>")

-- Quickfix controls
vim.keymap.set("n", "<Leader>d", cmd("copen") .. "<C-w>p")
vim.keymap.set("n", "<Leader>D", cmd("copen"))
vim.keymap.set("n", "<Leader>c", cmd("cclose") .. cmd("lclose"))

-- Move selected lines up and down
vim.keymap.set("v", "<C-k>", ":move '<-2<Return>gv=gv", { silent = true })
vim.keymap.set("v", "<C-j>", ":move '>+1<Return>gv=gv", { silent = true })

-- Resize windows
vim.keymap.set("n", "<C-j>", cmd("resize -1"))
vim.keymap.set("n", "<C-k>", cmd("resize +1"))
vim.keymap.set("n", "<C-h>", cmd("vertical resize -2"))
vim.keymap.set("n", "<C-l>", cmd("vertical resize +2"))

-- Stay in visual mode on indent/dedent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Make current file
vim.keymap.set("n", "<Leader>m", cmd("silent make"))

-- Write and quit
vim.keymap.set("n", "<Leader>w", cmd("write"))
vim.keymap.set("n", "<Leader>q", cmd("quit"))

-- Scroll in insert mode
vim.keymap.set("i", "<C-e>", "<C-o><C-e>")
vim.keymap.set("i", "<C-y>", "<C-o><C-y>")

-- Do not save paragraph jumps to the jumplist
vim.keymap.set({ "n", "v" }, "{", cmd([[execute "keepjumps normal! " . v:count1 . "{zz"]]))
vim.keymap.set({ "n", "v" }, "}", cmd([[execute "keepjumps normal! " . v:count1 . "}zz"]]))

---@param open string
---@param close string
local function surround(open, close)
    return "<Esc>`>a" .. close .. "<Esc>`<i" .. open .. "<Esc>gv" .. ("ol"):rep(2 * open:len())
end

-- Surround selected text
vim.keymap.set("v", "s(",  surround("(", ")"))
vim.keymap.set("v", "s{",  surround("{", "}"))
vim.keymap.set("v", "s[",  surround("[", "]"))
vim.keymap.set("v", "s<",  surround("<", ">"))
vim.keymap.set("v", "s|",  surround("|", "|"))
vim.keymap.set("v", "s*",  surround("*", "*"))
vim.keymap.set("v", "s`",  surround("`", "`"))
vim.keymap.set("v", "s'",  surround("'", "'"))
vim.keymap.set("v", "s\"", surround("\"", "\""))
vim.keymap.set("v", "s/",  surround("/*", "*/"))

-- Center the cursor after movements
for _, movement in ipairs({ "G", "n", "N", "<C-d>", "<C-u>" }) do
    vim.keymap.set({ "n", "v" }, movement, movement .. "zz")
end
