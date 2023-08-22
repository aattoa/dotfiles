vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Toggle search highlight
vim.keymap.set("n", "<leader>h", ":set hlsearch!<return>")
-- Toggle line numbers
vim.keymap.set("n", "<leader>n", ":set number!<return>")

-- Try to keep the cursor centered
vim.keymap.set("n", "G",     "Gzz")
vim.keymap.set("n", "n",     "nzz")
vim.keymap.set("n", "N",     "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "{",     "{zz")
vim.keymap.set("n", "}",     "}zz")

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<C-k>", ":m .-2<return>==") -- Single line up
vim.keymap.set("n", "<C-j>", ":m .+1<return>==") -- Single line down
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv") -- Selected lines up
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv") -- Selected lines down

-- Movement
vim.keymap.set("n", "\"", "10kzz")
vim.keymap.set("v", "\"", "10kzz")
vim.keymap.set("n", "|",  "10jzz")
vim.keymap.set("v", "|",  "10jzz")

-- Disable arrow keys
vim.keymap.set("n", "<Up>",    "")
vim.keymap.set("v", "<Up>",    "")
vim.keymap.set("i", "<Up>",    "")
vim.keymap.set("n", "<Down>",  "")
vim.keymap.set("v", "<Down>",  "")
vim.keymap.set("i", "<Down>",  "")
vim.keymap.set("n", "<Left>",  "")
vim.keymap.set("v", "<Left>",  "")
vim.keymap.set("i", "<Left>",  "")
vim.keymap.set("n", "<Right>", "")
vim.keymap.set("v", "<Right>", "")
vim.keymap.set("i", "<Right>", "")
