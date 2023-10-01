--[[
    n: normal
    i: insert
    v: visual
    x: visual block
    t: terminal
    c: command
]]

-- Explore with Netrw
vim.keymap.set("n", "<Leader>e", vim.cmd.Explore)

-- Switch to previously open buffer
vim.keymap.set("n", "<Leader><", "<C-^>")

-- Language server protocol
vim.keymap.set("n", "<Leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<Leader>ln", vim.lsp.buf.rename)
vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action)

-- Fuzzy finding with telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<Leader>f",  telescope.find_files)
vim.keymap.set("n", "<Leader>/",  function () telescope.find_files({ cwd = "$HOME" }) end)
vim.keymap.set("n", "<Leader>m",  function () telescope.man_pages({ sections = {"ALL"} }) end)
vim.keymap.set("n", "<Leader>o",  telescope.oldfiles)
vim.keymap.set("n", "<Leader>r",  telescope.live_grep)
vim.keymap.set("n", "<Leader>lr", telescope.lsp_references)
vim.keymap.set("n", "?",          telescope.help_tags)

-- Extract URLs from current buffer
vim.keymap.set("n", "<Leader>u", ":call system(\"handle-urls\", join(getline(1, '$'), \"\\n\"))<Return>")

-- Toggle diagnostics window
vim.keymap.set("n", "<Leader>d", vim.cmd.TroubleToggle)

-- Toggle search highlight
vim.keymap.set({ "n", "v" }, "<Leader>h", ":set hlsearch!<Return>")

-- Toggle line numbers
vim.keymap.set({ "n", "v" }, "<Leader>n", ":set number!<Return>:set relativenumber!<Return>")

-- System clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", "\"+")
vim.keymap.set("i", "<C-c>", "<Esc>\"+yya")

-- Search and replace
vim.keymap.set("n", "<C-s>", ":%s//g<Left><Left>")
vim.keymap.set("v", "<C-s>", ":s//g<Left><Left>")

-- Count search results
vim.keymap.set("n", "<C-n>", ":%s///gn<Left><Left><Left><Left>")
vim.keymap.set("v", "<C-n>", ":s///gn<Left><Left><Left><Left>")

-- Tab controls
vim.keymap.set("n", "<C-t>",   vim.cmd.tabnew)
vim.keymap.set("n", "<C-q>",   vim.cmd.tabclose)
vim.keymap.set("n", "<Tab>",   vim.cmd.tabnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.tabprevious)
vim.keymap.set("n", "g<",      ":tabmove -1<Return>")
vim.keymap.set("n", "g>",      ":tabmove +1<Return>")

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<C-k>", ":m .-2<Return>==") -- Current line up
vim.keymap.set("n", "<C-j>", ":m .+1<Return>==") -- Current line down
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv") -- Selected lines up
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv") -- Selected lines down

-- Window resizing
vim.keymap.set("n", "<C-M-k>", ":resize -1<Return>")
vim.keymap.set("n", "<C-M-j>", ":resize +1<Return>")
vim.keymap.set("n", "<C-M-h>", ":vertical resize +2<Return>")
vim.keymap.set("n", "<C-M-l>", ":vertical resize -2<Return>")

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
