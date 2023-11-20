local telescope = require("telescope.builtin")

vim.keymap.set("n", "<Leader>f",  telescope.find_files)
vim.keymap.set("n", "<Leader>/",  function () telescope.find_files({ cwd = "$HOME" }) end)
vim.keymap.set("n", "<Leader>m",  function () telescope.man_pages({ sections = { "ALL" } }) end)
vim.keymap.set("n", "<Leader>o",  telescope.oldfiles)
vim.keymap.set("n", "<Leader>r",  telescope.live_grep)
vim.keymap.set("n", "<Leader>lf", telescope.lsp_references)
vim.keymap.set("n", "<Leader>ls", telescope.lsp_document_symbols)
vim.keymap.set("n", "?",          telescope.help_tags)
