local telescope = require("telescope.builtin")

---@return boolean
local function is_git_dir()
    return vim.fn.finddir(".git", ".;" .. vim.fn.expand("$HOME")) ~= ""
end

vim.keymap.set("n", "<Leader>f",  function ()
    if is_git_dir() then
        telescope.git_files({ show_untracked = true })
    else
        telescope.find_files()
    end
end)
vim.keymap.set("n", "<Leader>`",  function () telescope.find_files({ cwd = "$HOME" }) end)
vim.keymap.set("n", "<Leader>m",  function () telescope.man_pages({ sections = { "ALL" } }) end)
vim.keymap.set("n", "<Leader>/",  telescope.find_files)
vim.keymap.set("n", "<Leader>o",  telescope.oldfiles)
vim.keymap.set("n", "<Leader>r",  telescope.live_grep)
vim.keymap.set("n", "<Leader>lf", telescope.lsp_references)
vim.keymap.set("n", "<Leader>ls", telescope.lsp_document_symbols)
vim.keymap.set("n", "?",          telescope.help_tags)
