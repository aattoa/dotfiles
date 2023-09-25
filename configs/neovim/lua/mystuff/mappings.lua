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
vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename)

-- Toggle search highlight
vim.keymap.set({ "n", "v" }, "<leader>h", ":set hlsearch!<return>")

-- Toggle line numbers
vim.keymap.set({ "n", "v" }, "<leader>n", ":set number!<return>:set relativenumber!<return>")

-- Search and replace
vim.keymap.set("n", "<C-s>", ":%s//g<Left><Left>")
vim.keymap.set("v", "<C-s>", ":s//g<Left><Left>")

-- Count search results
vim.keymap.set("n", "<C-n>", ":%s///gn<Left><Left><Left><Left>")
vim.keymap.set("v", "<C-n>", ":s///gn<Left><Left><Left><Left>")

-- Extract URLs from current buffer
vim.keymap.set("n", "<C-M-u>", ":call system(\"handle-urls\", join(getline(1, '$'), \"\\n\"))<return>")

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

-- Emulate normal mode navigation in command mode
vim.keymap.set("c", "<C-b>", "<S-Left>")
vim.keymap.set("c", "<C-w>", "<S-Right>")
vim.keymap.set("c", "<C-h>", "<Left>")
vim.keymap.set("c", "<C-j>", "<Down>")
vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-l>", "<Right>")

---@param movements table
local function center_cursor_after_movements(movements)
    for _, movement in ipairs(movements) do
        vim.keymap.set({ "n", "v" }, movement, movement .. "zz")
    end
end

-- Try to keep the cursor centered
center_cursor_after_movements { "G", "n", "N", "<C-d>", "<C-u>", "{", "}" }
