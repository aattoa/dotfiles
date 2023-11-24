return {
    "vimwiki/vimwiki",
    init = function ()
        vim.g.vimwiki_list = {{ path = "$HOME/misc/vimwiki", syntax = "markdown", ext = ".md" }}
    end,
    config = function ()
        -- Avoid clashing bindings
        vim.keymap.set("n", "<Leader>wj", "<Plug>VimwikiNextLink", { remap = true }) -- Mapped to <Tab> by default
        vim.keymap.set("n", "<Leader>wk", "<Plug>VimwikiPrevLink", { remap = true }) -- Mapped to <S-Tab> by default
    end,
    event = { "BufReadPre *.md" },
    keys  = { "<Leader>ww" },
}
