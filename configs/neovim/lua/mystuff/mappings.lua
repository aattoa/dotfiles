--[[
    n: normal
    i: insert
    v: visual
    x: visual block
    t: terminal
    c: command
]]

-- Explore with Netrw
vim.keymap.set("n", "<leader>e", vim.cmd.Explore)

-- Switch to previously open buffer
vim.keymap.set("n", "<leader><", "<C-^>")

-- Language server protocol
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references)

-- Toggle search highlight
vim.keymap.set("n", "<leader>h", ":set hlsearch!<return>")

-- Toggle line numbers
vim.keymap.set("n", "<leader>n", ":set number!<return>:set relativenumber!<return>")

-- Search and replace
vim.keymap.set("n", "<C-s>", ":%s//g<Left><Left>")

-- Normal mode on selected lines
vim.keymap.set("v", "<C-n>", ":normal ")

-- Tab controls
vim.keymap.set("n", "<C-t>",   vim.cmd.tabnew)
vim.keymap.set("n", "<C-q>",   vim.cmd.tabclose)
vim.keymap.set("n", "<Tab>",   vim.cmd.tabnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.tabprevious)
vim.keymap.set("n", "g<",      ":tabmove -1<return>")
vim.keymap.set("n", "g>",      ":tabmove +1<return>")

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<C-k>", ":m .-2<return>==") -- Current line up
vim.keymap.set("n", "<C-j>", ":m .+1<return>==") -- Current line down
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv") -- Selected lines up
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv") -- Selected lines down

-- Window resizing
vim.keymap.set("n", "<C-M-k>", ":resize -1<return>")
vim.keymap.set("n", "<C-M-j>", ":resize +1<return>")
vim.keymap.set("n", "<C-M-h>", ":vertical resize +2<return>")
vim.keymap.set("n", "<C-M-l>", ":vertical resize -2<return>")

-- Stay in visual mode on indent/dedent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- System clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", "\"+y")
vim.keymap.set({ "n", "v" }, "<C-p>", "\"+p")

-- Disable arrow keys
vim.keymap.set({ "n", "v", "i" }, "<Up>",    "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<Down>",  "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<Left>",  "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<Right>", "<Nop>")

---@param movements table
local function center_cursor_after_movements(movements)
    for _, movement in ipairs(movements) do
        vim.keymap.set({ "n", "v" }, movement, movement .. "zz")
    end
end

-- Try to keep the cursor centered
center_cursor_after_movements { "G", "n", "N", "<C-d>", "<C-u>", "{", "}" }
