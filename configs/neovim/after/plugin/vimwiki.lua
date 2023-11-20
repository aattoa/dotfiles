vim.g.vimwiki_list = {{ path = "$HOME/misc/vimwiki", syntax = "markdown", ext = ".md" }}
vim.cmd "call vimwiki#vars#init()"

-- Avoid clashing bindings
vim.keymap.set("n", "<Leader>wj", "<Plug>VimwikiNextLink", { remap = true }) -- Mapped to <Tab> by default
vim.keymap.set("n", "<Leader>wk", "<Plug>VimwikiPrevLink", { remap = true }) -- Mapped to <S-Tab> by default
