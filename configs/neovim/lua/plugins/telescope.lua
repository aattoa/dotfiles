---@return boolean
local function is_git_dir()
    return next(vim.fs.find(".git", { upward = true, stop = vim.loop.os_homedir() }))
end

local function git_files_or_fallback()
    if is_git_dir() then
        require("telescope.builtin").git_files { show_untracked = true }
    else
        require("telescope.builtin").find_files {}
    end
end

---@param builtin string
---@param options table|nil
---@return function
local function telescope(builtin, options)
    return function ()
        require("telescope.builtin")[builtin](options)
    end
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

        { "<Leader>sd", telescope("git_files",  { cwd = "$MY_DOTFILES_REPO",    prompt_title = "Dotfiles", show_untracked = true }) },
        { "<Leader>sh", telescope("find_files", { cwd = "$HOME", hidden = true, prompt_title = "Home directory" }) },
        { "<Leader>sm", telescope("man_pages",  { sections = { "ALL" },         prompt_title = "Manuals" }) },

        { "<Leader>lf", telescope("lsp_references") },
        { "<Leader>ls", telescope("lsp_document_symbols") },
    },
    config = function ()
        vim.keymap.set("n", "<Leader><BS>", require("telescope.builtin").resume)
    end,
}
