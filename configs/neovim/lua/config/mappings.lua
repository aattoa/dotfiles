---@type fun(command: string): string
local function cmd(command)
    return "<Cmd>" .. command .. "<CR>"
end

-- Leader by itself does nothing
vim.keymap.set({ "n", "x" }, "<Leader>", "<Nop>")

-- Toggle search case sensitivity
vim.keymap.set("n", "<Leader>i", cmd("set ignorecase!"))

-- Toggle search highlight
vim.keymap.set("n", "<Leader>h", cmd("set hlsearch!"))

-- Toggle line number visibility
vim.keymap.set("n", "<Leader>n", cmd("set number!") .. cmd("set relativenumber!"))

-- Handle URLs in current buffer
vim.keymap.set("n", "<Leader>u", cmd("call system('handle-urls', bufnr())"))

-- Jumplist navigation (necessary because <C-i> conflicts with <Tab>)
vim.keymap.set("n", "<Leader>j", "<C-o>zz")
vim.keymap.set("n", "<Leader>k", "<C-i>zz")

-- Easier alternate file access
vim.keymap.set("n", "L", "<C-^>")

-- System clipboard
vim.keymap.set({ "n", "x" }, "<C-c>", "\"+")

-- Symmetric command-line window toggle
vim.keymap.set("n", "<C-f>", "<C-c>")

-- Explore with Netrw
vim.keymap.set("n", "<Leader>e",     cmd("Explore"))
vim.keymap.set("n", "<Leader>E",     cmd("Sexplore"))
vim.keymap.set("n", "<Leader><C-e>", cmd("Texplore"))

-- Tab controls
vim.keymap.set("n", "<C-t>",   cmd("tabnew"))
vim.keymap.set("n", "<C-q>",   cmd("tabclose"))
vim.keymap.set("n", "<Tab>",   cmd("tabnext"))
vim.keymap.set("n", "<S-Tab>", cmd("tabprevious"))
vim.keymap.set("n", "<<",      cmd("tabmove -1"))
vim.keymap.set("n", ">>",      cmd("tabmove +1"))

for i = 1, 9 do
    vim.keymap.set("n", "<Leader>" .. i, i .. "gt")
end
vim.keymap.set("n", "<Leader>0", "g<Tab>")

-- Quickfix controls
vim.keymap.set("n", "<Leader>d", cmd("copen") .. "<C-w>p")
vim.keymap.set("n", "<Leader>D", cmd("copen"))
vim.keymap.set("n", "<Leader>c", cmd("cclose") .. cmd("lclose"))

-- Move selected lines up and down
vim.keymap.set("x", "<C-k>", ":move '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("x", "<C-j>", ":move '>+1<CR>gv=gv", { silent = true })

-- Resize windows
vim.keymap.set("n", "<C-j>", cmd("horizontal resize -1"))
vim.keymap.set("n", "<C-k>", cmd("horizontal resize +1"))
vim.keymap.set("n", "<C-h>", cmd("vertical resize -2"))
vim.keymap.set("n", "<C-l>", cmd("vertical resize +2"))

-- Stay in visual mode on indent/dedent
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Write and quit
vim.keymap.set("n", "<Leader>w", cmd("write"))
vim.keymap.set("n", "<Leader>q", cmd("quit"))

-- Normal mode actions in insert mode
vim.keymap.set("i", "<C-e>", "<C-o><C-e>")
vim.keymap.set("i", "<C-y>", "<C-o><C-y>")
vim.keymap.set("i", "<C-z>", "<C-o>zz")

-- Do not save paragraph jumps to the jumplist
vim.keymap.set({ "n", "x" }, "{", cmd([[execute "keepjumps normal! " . v:count1 . "{zz"]]))
vim.keymap.set({ "n", "x" }, "}", cmd([[execute "keepjumps normal! " . v:count1 . "}zz"]]))

---@type fun(open: string, close: string): string
local function surround(open, close)
    return "<Esc>`>a" .. close .. "<Esc>`<i" .. open .. "<Esc>gv" .. string.rep("ol", 2 * open:len())
end

-- Surround selected text
vim.keymap.set("x", "s(",  surround("(", ")"))
vim.keymap.set("x", "s{",  surround("{", "}"))
vim.keymap.set("x", "s[",  surround("[", "]"))
vim.keymap.set("x", "s<",  surround("<", ">"))
vim.keymap.set("x", "s|",  surround("|", "|"))
vim.keymap.set("x", "s*",  surround("*", "*"))
vim.keymap.set("x", "s`",  surround("`", "`"))
vim.keymap.set("x", "s'",  surround("'", "'"))
vim.keymap.set("x", "s ",  surround(" ", " "))
vim.keymap.set("x", "s\"", surround("\"", "\""))
vim.keymap.set("x", "s/",  surround("/*", "*/"))

-- Center the cursor after movements
for _, movement in ipairs({ "G", "n", "N", "<C-d>", "<C-u>" }) do
    vim.keymap.set({ "n", "x" }, movement, movement .. "zz")
end

-- Accept completion
vim.keymap.set("i", "<CR>", "pumvisible() ? '<C-y>' : '<CR>'", { expr = true })

-- Clear current search highlight or active snippet
vim.keymap.set("n", "<Esc>", function ()
    return vim.snippet.active() and vim.snippet.exit() or cmd("nohlsearch")
end, { expr = true })

-- Rotate alphabet
vim.keymap.set("i", "<C-a>", require("util.alphabet").rotate)

-- Snippet controls
vim.keymap.set({ "i", "s" }, "<C-j>", require("util.snippet").expand_or_jump)
vim.keymap.set({ "i", "s" }, "<C-k>", function () vim.snippet.jump(-1) end)

-- Comment and uncomment
vim.keymap.set({ "n", "x" }, "<C-s><C-s>", require("util.comment").toggle)
vim.keymap.set({ "n", "x" }, "<C-s><C-k>", require("util.comment").comment)
vim.keymap.set({ "n", "x" }, "<C-s><C-c>", require("util.comment").uncomment)
