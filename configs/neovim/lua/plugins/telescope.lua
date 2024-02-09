---@return boolean
local function is_git_dir()
    return next(vim.fs.find(".git", { upward = true, stop = vim.loop.os_homedir() }))
end

local function git_files_or_fallback()
    if is_git_dir() then
        require("telescope.builtin").git_files({ show_untracked = true })
    else
        require("telescope.builtin").find_files()
    end
end

---@param builtin string
---@param options table|nil
---@return function
local function telescope(builtin, options)
    return function () require("telescope.builtin")[builtin](options) end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<Leader>f",  git_files_or_fallback },
        { "<Leader>/",  telescope("find_files") },
        { "<Leader>o",  telescope("oldfiles") },
        { "<Leader>r",  telescope("live_grep") },
        { "?",          telescope("help_tags") },
        { "<Leader>sd", telescope("git_files",  { cwd = "$MY_DOTFILES_REPO", prompt_title = "Dotfiles", show_untracked = true }) },
        { "<Leader>sh", telescope("find_files", { cwd = "$HOME",             prompt_title = "Home", hidden = true }) },
        { "<Leader>sm", telescope("man_pages",  { sections = { "ALL" },      prompt_title = "Manuals" }) },
        { "<Leader>lf", telescope("lsp_references") },
        { "<Leader>ls", telescope("lsp_document_symbols") },
    },
    config = function ()
        local actions = require("telescope.actions")
        local scroll_maps = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
        }
        require("telescope").setup {
            defaults = {
                mappings = {
                    n = scroll_maps,
                    i = scroll_maps,
                },
            },
        }
        -- This is not in the `keys` table, because resume only
        -- makes sense when a picker has already been invoked.
        vim.keymap.set("n", "<Leader><Backspace>", telescope("resume"))
    end,
}
