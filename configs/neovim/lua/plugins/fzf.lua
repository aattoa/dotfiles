---@param builtin string
---@param options? table
local function fzf(builtin, options)
    return function () require('fzf-lua')[builtin](options) end
end

return {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
        { '<leader>o',    fzf('oldfiles') },
        { '<leader>r',    fzf('live_grep_native') },
        { '<leader>f',    fzf('files') },
        { '<leader>?',    fzf('helptags') },
        { '<leader>/',    fzf('blines',           { prompt = 'Buffer> ' }) },
        { '<leader>g',    fzf('git_files',        { prompt = 'Git> ' }) },
        { '<leader>sd',   fzf('files',            { prompt = 'Dotfiles> ', cwd = '$MY_DOTFILES_REPO' }) },
        { '<leader>sD',   fzf('live_grep_native', { prompt = 'Dotfiles> ', cwd = '$MY_DOTFILES_REPO' }) },
        { '<leader>sh',   fzf('files',            { prompt = 'Home> ',     cwd = '$HOME' }) },
        { '<leader>sm',   fzf('manpages') },
        { '<leader>sf',   fzf('builtin') },
        { '<leader><bs>', fzf('resume') },
        { '<c-f>',        fzf('complete_file'), mode = 'i' },
    },
    config = function ()
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'fzf',
            command = 'tnoremap <buffer> <nowait> <esc> <esc>',
            desc    = 'Hide global terminal mode mapping <esc><esc>',
        })

        local actions = require('fzf-lua.actions')

        require('fzf-lua').setup({
            winopts = {
                preview = {
                    delay  = 0,
                    hidden = 'hidden',
                },
            },
            fzf_opts = {
                ['--layout'] = 'default',
            },
            keymap = {
                builtin = {
                    ['<f1>']  = 'toggle-help',
                    ['<c-a>'] = 'toggle-preview',
                    ['<c-r>'] = 'toggle-preview-cw',
                    ['<c-f>'] = 'toggle-fullscreen',
                    ['<c-p>'] = 'preview-page-up',
                    ['<c-n>'] = 'preview-page-down',
                },
                fzf = {}, -- Use systemwide fzf bindings
            },
            grep = {
                actions = {
                    ['ctrl-g'] = false,
                    ['ctrl-q'] = actions.toggle_ignore,
                    ['ctrl-o'] = actions.grep_lgrep,
                },
                cwd_header  = false,
                no_header_i = true,
            },
            files = {
                actions = {
                    ['ctrl-g'] = false,
                    ['ctrl-q'] = actions.toggle_ignore,
                },
                git_icons   = false,
                cwd_prompt  = false,
                cwd_header  = false,
                no_header_i = true,
            },
            complete_file = {
                file_icons = false,
                winopts = { preview = { hidden = 'nohidden' } },
            },
            previewers = {
                man = { cmd = 'man %s | col --spaces --no-backspaces' },
            },
        })
    end,
}
