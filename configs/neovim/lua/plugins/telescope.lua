---@param builtin string
---@param options? table
local function telescope(builtin, options)
    return function ()
        require("telescope.builtin")[builtin](options)
    end
end

---@param actions table
local function mappings(actions)
    return {
        n = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
        },
        i = {
            ["<C-k>"] = actions.results_scrolling_up,
            ["<C-j>"] = actions.results_scrolling_down,
            ["<C-h>"] = actions.results_scrolling_left,
            ["<C-l>"] = actions.results_scrolling_right,
        },
    }
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
        { "<Leader>/",  telescope("current_buffer_fuzzy_find",              { prompt_title = "Buffer fuzzy" }) },
        { "<Leader>o",  telescope("oldfiles",                               { prompt_title = "Recent files" }) },
        { "<Leader>r",  telescope("live_grep",   { path_display = { "tail" }, prompt_title = "g/re/p" }) },
        { "<Leader>f",  telescope("find_files",  { hidden = false,            prompt_title = "Find files" }) },
        { "<Leader>F",  telescope("find_files",  { hidden = true,             prompt_title = "Find files (with hidden)" }) },
        { "<Leader>g",  telescope("git_files",   { show_untracked = false,    prompt_title = "Git files" }) },
        { "<Leader>G",  telescope("git_files",   { show_untracked = true,     prompt_title = "Git files (with untracked)" }) },
        { "<Leader>sd", telescope("find_files",  { cwd = "$MY_DOTFILES_REPO", prompt_title = "Dotfiles" }) },
        { "<Leader>sh", telescope("find_files",  { cwd = "$HOME",             prompt_title = "Home" }) },
        { "<Leader>sm", telescope("man_pages",   { sections = { "ALL" },      prompt_title = "Manuals" }) },
        { "<Leader>sb", telescope("buffers") },
        { "<Leader>st", telescope("builtin") },
        { "?",          telescope("help_tags") },
    },
    config = function ()
        require("telescope").setup({
            defaults = {
                mappings        = mappings(require("telescope.actions")),
                layout_config   = { scroll_speed = 3 },
                scroll_strategy = "limit",
            },
            pickers = {
                current_buffer_fuzzy_find = {
                    sorting_strategy = "ascending",
                    skip_empty_lines = true,
                    previewer        = false,
                },
                buffers = {
                    ignore_current_buffer = true,
                },
            },
        })
        -- This is not in the `keys` table, because resume only makes sense when a picker has already been invoked.
        vim.keymap.set("n", "<Leader><Backspace>", telescope("resume"))
    end,
}
