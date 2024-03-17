---@param builtin string
---@param options nil|table
local function telescope(builtin, options)
    return function ()
        require("telescope.builtin")[builtin](options)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<Leader>f",  telescope("find_files") },
        { "<Leader>o",  telescope("oldfiles") },
        { "<Leader>r",  telescope("live_grep") },
        { "<Leader>g",  telescope("git_files",   { show_untracked = true,     prompt_title = "Git files with untracked" }) },
        { "<Leader>G",  telescope("git_files",   { show_untracked = false,    prompt_title = "Git files without untracked" }) },
        { "<Leader>sd", telescope("find_files",  { cwd = "$MY_DOTFILES_REPO", prompt_title = "Dotfiles" }) },
        { "<Leader>sh", telescope("find_files",  { cwd = "$HOME",             prompt_title = "Home", hidden = true }) },
        { "<Leader>sm", telescope("man_pages",   { sections = { "ALL" },      prompt_title = "Manuals" }) },
        { "<Leader>ls", telescope("lsp_document_symbols") },
        { "?",          telescope("help_tags") },
    },
    config = function ()
        local actions = require("telescope.actions")
        local scroll_maps = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
        }
        require("telescope").setup({
            defaults = {
                mappings = {
                    n = scroll_maps,
                    i = scroll_maps,
                },
            },
        })
        -- This is not in the `keys` table, because resume only makes sense when a picker has already been invoked.
        vim.keymap.set("n", "<Leader><Backspace>", telescope("resume"))
    end,
}
