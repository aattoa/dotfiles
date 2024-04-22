---@param builtin string
---@param options? table
local function fzf(builtin, options)
    return function () require("fzf-lua")[builtin](options) end
end

return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<Leader>o",    fzf("oldfiles") },
        { "<Leader>r",    fzf("live_grep_native") },
        { "<Leader>f",    fzf("files") },
        { "<Leader>g",    fzf("git_files",        { prompt = "Git>" }) },
        { "<Leader>/",    fzf("blines",           { prompt = "Buffer>" }) },
        { "<Leader>sd",   fzf("files",            { prompt = "Dotfiles>", cwd = "$MY_DOTFILES_REPO" }) },
        { "<Leader>sD",   fzf("live_grep_native", { prompt = "Dotfiles>", cwd = "$MY_DOTFILES_REPO" }) },
        { "<Leader>sh",   fzf("files",            { prompt = "Home>",     cwd = "$HOME" }) },
        { "<Leader>sm",   fzf("manpages") },
        { "<Leader>sf",   fzf("builtin") },
        { "<Leader><BS>", fzf("resume") },
        { "<C-f>",        fzf("complete_file"), mode = "i" },
        { "?",            fzf("helptags") },
    },
    config = function ()
        local actions = require("fzf-lua.actions")
        require("fzf-lua").setup({
            winopts = {
                preview = { delay = 0 },
            },
            fzf_opts = {
                ["--layout"] = "default",
            },
            keymap = {
                builtin = {
                    ["<C-a>"] = "toggle-preview",
                    ["<C-r>"] = "toggle-preview-cw",
                    ["<C-f>"] = "toggle-fullscreen",
                    ["<C-p>"] = "preview-page-up",
                    ["<C-n>"] = "preview-page-down",
                },
            },
            grep = {
                actions = {
                    ["ctrl-g"] = false,
                    ["ctrl-q"] = actions.toggle_ignore,
                    ["ctrl-o"] = actions.grep_lgrep,
                },
                no_header_i = true,
            },
            files = {
                actions = {
                    ["ctrl-g"] = false,
                    ["ctrl-q"] = actions.toggle_ignore,
                },
                git_icons   = false,
                cwd_prompt  = false,
                no_header_i = true,
            },
            oldfiles = {
                winopts = { preview = { hidden = "hidden" } },
            },
            complete_file = {
                file_icons = false,
                winopts = { preview = { hidden = "nohidden" } },
            },
            previewers = {
                man = { cmd = "man %s | col --spaces --no-backspaces" },
            },
        })
    end,
}
