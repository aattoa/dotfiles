---@class FzfOptions
---@field command    string
---@field fzfargs    string?
---@field prompt     string?
---@field title      string?
---@field directory  string?
---@field scale      number?
---@field fullscreen boolean?
---@field on_buffer  fun(buffer: integer)?
---@field on_window  fun(window: integer)?
---@field on_result  fun(lines: string[])

---@type FzfOptions?
local previous_fzf_options

---@type fun(buffer: integer, options: FzfOptions): integer
local function open_fzf_window(buffer, options)
    local scale  = options.fullscreen and 1 or options.scale or 0.75
    local width  = vim.o.columns
    local height = vim.o.lines - (options.fullscreen and (vim.o.cmdheight + 3) or 0)

    local window = vim.api.nvim_open_win(buffer, true, {
        relative   = 'editor',
        width      = math.floor(width  * scale),
        height     = math.floor(height * scale),
        col        = math.floor(width  * (1 - scale) / 2),
        row        = math.floor(height * (1 - scale) / 2),
        border     = vim.g.floatborder,
        footer     = options.title and { { options.title, 'ModeMsg' } },
        footer_pos = options.title and 'center',
    })

    if options.on_window then
        options.on_window(window)
    end
    return window
end

---@type fun(buffer: integer, options: FzfOptions): integer
local function start_fzf_job(buffer, options)
    local defaults = '--no-scrollbar --info=inline-right'
    local prompt   = options.prompt and string.format('--prompt="%s> "', options.prompt) or ''
    local result   = vim.fn.tempname()
    local fzf      = string.format('fzf %s %s %s', defaults, options.fzfargs, prompt)
    local command  = string.format('%s | %s 2>/dev/null 1>%s', options.command, fzf, result)

    return vim.api.nvim_buf_call(buffer, function ()
        return vim.fn.termopen(command, {
            on_exit = function (_, code)
                vim.api.nvim_buf_delete(buffer, {})
                if code == 0 then
                    options.on_result(vim.fn.readfile(result))
                end
                vim.fn.delete(result)
            end,
            cwd = options.directory,
        })
    end)
end

---@param options FzfOptions
local function run_fzf(options)
    previous_fzf_options = options

    local buffer = vim.api.nvim_create_buf(false, false)
    local window = open_fzf_window(buffer, options)

    vim.bo[buffer].filetype = 'fzf'
    if options.on_buffer then
        options.on_buffer(buffer)
    end

    local job = start_fzf_job(buffer, options)
    if not job or job == 0 or job == -1 then
        vim.notify('could not start job: ' .. options.command, vim.log.levels.ERROR)
        return
    end

    local function reopen_window()
        vim.api.nvim_win_close(window, false)
        window = open_fzf_window(buffer, options)
    end

    local function toggle_fullscreen()
        options.fullscreen = not options.fullscreen
        reopen_window()
        vim.api.nvim_feedkeys(vim.keycode('<c-\\><c-n>i'), 'n', false)
    end

    vim.keymap.set('t', '<c-f>', toggle_fullscreen, {
        buffer = buffer,
        desc   = 'fzf: Toggle fullscreen',
    })

    vim.api.nvim_create_autocmd('VimResized', {
        callback = reopen_window,
        buffer   = buffer,
        desc     = 'fzf: Resize window',
    })
end

---@type fun(root: string?, path: string): string
local function path_argument(root, path)
    return vim.fn.fnameescape(root and vim.fs.joinpath(root, path) or path)
end

---@type fun(command: string, prompt: string?, root: string?): function
local function fzf_files(command, prompt, root)
    local function on_files(files)
        if #files == 1 then
            vim.fn.execute('edit ' .. path_argument(root, files[1]))
        else
            vim.iter(files):each(function (file)
                vim.fn.execute('tabedit ' .. path_argument(root, file))
            end)
        end
    end
    return function()
        run_fzf({
            command   = command,
            fzfargs   = '--multi --scheme=path',
            prompt    = prompt,
            directory = root,
            on_result = on_files,
        })
    end
end

---@type fun(prompt: string?, root: string?): function
local function fzf_grep(prompt, root)
    return function ()
        run_fzf({
            command   = 'rg . --line-number --field-match-separator=\\\\0:',
            fzfargs   = '--tac --tiebreak=end --preview=""', -- todo
            prompt    = prompt,
            directory = root,
            on_result = function (lines)
                local path, line = lines[1]:match('^([^\n]+)\n:([0-9]+)\n:')
                vim.fn.execute(string.format('edit +normal\\ %sggzz %s', line, path_argument(root, path)))
            end,
            on_window = vim.fn.clearmatches,
        })
    end
end

local function fzf_buffer_lines()
    run_fzf({
        command = 'nl --body-numbering=a --number-format=ln ' .. vim.fn.shellescape(vim.fn.expand('%')),
        fzfargs = '--tac --no-sort',
        prompt  = 'Buffer',
        on_result = function(lines)
            vim.cmd.normal(lines[1]:match('^[0-9]+') .. 'ggzz')
        end,
    })
end

local function fzf_help_tags()
    local tags_files = vim.fn.globpath(vim.o.runtimepath, vim.fs.joinpath('doc', 'tags'), nil, true)
    run_fzf({
        command = 'cat ' .. vim.iter(tags_files):map(vim.fn.shellescape):join(' '),
        fzfargs = '--preview=""', -- todo
        prompt  = 'Help',
        on_result = function (lines)
            vim.cmd.help(lines[1]:match('^([^\t]+)'))
            vim.bo.filetype = 'help'
        end,
    })
end

local function fzf_manpages()
    run_fzf({
        command = 'apropos .',
        fzfargs = [[--preview="echo {} | awk '{print\$1\$2}' | xargs man | col --spaces --no-backspaces"]],
        prompt  = 'Manpages',
        on_result = function (lines)
            local name, section = lines[1]:match('^(%S+)%s+%((.*)%)')
            vim.cmd.Man(section, name)
        end,
    })
end

local function fzf_resume()
    if previous_fzf_options then
        run_fzf(previous_fzf_options)
    else
        vim.notify('fzf has not been invoked yet', vim.log.levels.ERROR)
    end
end

local files    = 'fd --type f'
local allfiles = 'find -type f'
local gitfiles = 'git ls-files :/'
local oldfiles = [[nvim --headless --cmd rshada --cmd 'lua io.stdout:write(vim.fn.join(vim.v.oldfiles, "\n") .. "\n")' --cmd quit]]

vim.keymap.set('n', '<leader>f',    fzf_files(files))
vim.keymap.set('n', '<leader>F',    fzf_files(allfiles, 'All'))
vim.keymap.set('n', '<leader>g',    fzf_files(gitfiles, 'Git'))
vim.keymap.set('n', '<leader>o',    fzf_files(oldfiles, 'History'))
vim.keymap.set('n', '<leader>sh',   fzf_files(allfiles, 'Home', vim.env.HOME))
vim.keymap.set('n', '<leader>sd',   fzf_files(files,    'Dotfiles', vim.env.MY_DOTFILES_REPO))
vim.keymap.set('n', '<leader>sD',   fzf_grep('Dotfiles*', vim.env.MY_DOTFILES_REPO))
vim.keymap.set('n', '<leader>sm',   fzf_manpages)
vim.keymap.set('n', '<leader>r',    fzf_grep('Grep'))
vim.keymap.set('n', '<leader>?',    fzf_help_tags)
vim.keymap.set('n', '<leader>/',    fzf_buffer_lines)
vim.keymap.set('n', '<leader><bs>', fzf_resume)
