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

-- Language server protocol
vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename)
vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action)

-- Fuzzy finding with telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<Leader>f",  telescope.find_files)
vim.keymap.set("n", "<Leader>/",  function () telescope.find_files({ cwd = "$HOME" }) end)
vim.keymap.set("n", "<Leader>m",  function () telescope.man_pages({ sections = { "ALL" } }) end)
vim.keymap.set("n", "<Leader>o",  telescope.oldfiles)
vim.keymap.set("n", "<Leader>r",  telescope.live_grep)
vim.keymap.set("n", "<Leader>lf", telescope.lsp_references)
vim.keymap.set("n", "<Leader>ls", telescope.lsp_document_symbols)
vim.keymap.set("n", "?",          telescope.help_tags)

-- Extract URLs from current buffer
vim.keymap.set("n", "<Leader>u", ":call system(\"handle-urls\", join(getline(1, '$'), \"\\n\") .. \"\\n\")<Return>", { silent = true })

-- Toggle diagnostics window
vim.keymap.set("n", "<Leader>d", vim.cmd.TroubleToggle)

-- Overload helper
vim.keymap.set("i", "<C-Space>", vim.cmd.LspOverloadsSignature)

-- Toggle search case sensitivity
vim.keymap.set("n", "<Leader>i", ":set ignorecase!<Return>", { silent = true })

-- Toggle search highlight
vim.keymap.set("n", "<Leader>h", ":set hlsearch!<Return>", { silent = true })

-- Toggle line number visibility
vim.keymap.set("n", "<Leader>n", ":set number!<Return>:set relativenumber!<Return>", { silent = true })

-- System clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", "\"+")
vim.keymap.set("i", "<C-c>", "<Esc>\"+yya")

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
vim.keymap.set("n", "g<",      ":tabmove -1<Return>", { silent = true })
vim.keymap.set("n", "g>",      ":tabmove +1<Return>", { silent = true })

-- Avoid clashes with Vimwiki bindings
vim.keymap.set("n", "<Leader>wj", "<Plug>VimwikiNextLink", { remap = true }) -- Mapped to <Tab> by default
vim.keymap.set("n", "<Leader>wk", "<Plug>VimwikiPrevLink", { remap = true }) -- Mapped to <S-Tab> by default

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<C-k>", ":move .-2<Return>==",     { silent = true }) -- Current line up
vim.keymap.set("n", "<C-j>", ":move .+1<Return>==",     { silent = true }) -- Current line down
vim.keymap.set("v", "<C-k>", ":move '<-2<Return>gv=gv", { silent = true }) -- Selected lines up
vim.keymap.set("v", "<C-j>", ":move '>+1<Return>gv=gv", { silent = true }) -- Selected lines down

-- Window resizing
vim.keymap.set("n", "<C-M-k>", ":resize -1<Return>",          { silent = true })
vim.keymap.set("n", "<C-M-j>", ":resize +1<Return>",          { silent = true })
vim.keymap.set("n", "<C-M-l>", ":vertical resize +2<Return>", { silent = true })
vim.keymap.set("n", "<C-M-h>", ":vertical resize -2<Return>", { silent = true })

-- Stay in visual mode on indent/dedent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Toggle between latin and greek alphabets
vim.keymap.set("n", "<Leader>k", ALPHABET_TOGGLE)

-- Make current file
vim.keymap.set("n", "<Leader>a", ":silent make<Return>", { silent = true })

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
