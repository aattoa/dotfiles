vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Toggle search highlight
vim.keymap.set("n", "\\h", ":set hlsearch!<return>")
-- Toggle line numbers
vim.keymap.set("n", "\\n", ":set number!<return>")

-- Center the cursor on screen movements
vim.keymap.set("n", "G",     "Gzz")
vim.keymap.set("n", "n",     "nzz")
vim.keymap.set("n", "N",     "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<C-k>", ":m .-2<return>==") -- Single line up
vim.keymap.set("n", "<C-j>", ":m .+1<return>==") -- Single line down
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv") -- Selected lines up
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv") -- Selected lines down
