---@class FzfOptions
---@field command    string?
---@field fzfargs    string?
---@field prompt     string?
---@field query      string?
---@field directory  string?
---@field scale      number?
---@field fullscreen boolean?
---@field on_buffer  fun(buffer: integer)?
---@field on_window  fun(window: integer)?
---@field on_result  fun(line: string, accept: string)

---@type FzfOptions?
local previous_fzf_options

---@type fun(options: FzfOptions): vim.api.keyset.win_config
local function fzf_window_config(options)
    return require('user.scratch').window_config(options.fullscreen, options.scale)
end

---@type fun(buffer: integer, options: FzfOptions): integer
local function start_fzf_job(buffer, options)
    return vim.api.nvim_buf_call(buffer, function ()
        local result = vim.fn.tempname()
        return vim.fn.termopen('fzf 2>/dev/null 1>' .. result, {
            env = {
                FZF_DEFAULT_COMMAND = options.command,
                FZF_DEFAULT_OPTS = string.format(
                    '--print-query --expect=ctrl-t,ctrl-s,ctrl-v --multi --no-scrollbar --info=inline-right %s %s %s %s',
                    vim.env.FZF_DEFAULT_OPTS or '',
                    options.fzfargs or '',
                    options.prompt and string.format('--prompt=%s\\>\\ ', vim.fn.shellescape(options.prompt)) or '',
                    options.query and string.format('--query=%s', vim.fn.shellescape(options.query)) or ''),
            },
            on_exit = function (_, code)
                vim.api.nvim_buf_delete(buffer, {})
                if code == 0 then
                    local lines = io.lines(result)
                    previous_fzf_options.query = assert(lines())
                    local accept = assert(lines())
                    for line in lines do
                        options.on_result(line, accept)
                    end
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

    local buffer = vim.api.nvim_create_buf(false --[[listed]], false --[[scratch]])
    local window = vim.api.nvim_open_win(buffer, true --[[enter]], fzf_window_config(options))

    vim.fn.clearmatches(window)
    vim.bo[buffer].filetype = 'fzf'

    if options.on_buffer then options.on_buffer(buffer) end
    if options.on_window then options.on_window(window) end

    local job = start_fzf_job(buffer, options)
    if not job or job == 0 or job == -1 then
        vim.notify('could not start job: ' .. options.command, vim.log.levels.ERROR)
        return
    end

    local function reconfigure_window()
        vim.api.nvim_win_set_config(window, fzf_window_config(options))
    end
    local function toggle_fullscreen()
        options.fullscreen = not options.fullscreen
        reconfigure_window()
    end

    vim.keymap.set('t', '<c-f>', toggle_fullscreen, {
        buffer = buffer,
        desc   = 'fzf: Toggle fullscreen',
    })
    vim.api.nvim_create_autocmd('VimResized', {
        callback = reconfigure_window,
        buffer   = buffer,
        desc     = 'fzf: Resize window',
    })
end

---@class Location
---@field path string?
---@field line integer?
---@field column integer?

---@type fun(accept: string, location: Location)
local function edit_location(accept, location)
    local commands = { ['ctrl-t'] = 'tabedit', ['ctrl-s'] = 'new', ['ctrl-v'] = 'vnew' }
    vim.cmd[commands[accept] or 'edit'](location.path or '%')
    if location.line then
        vim.fn.cursor({ location.line, location.column or 1 })
        vim.cmd.normal('zz')
    end
end

---@param callback fun(result: string): Location
local function make_on_result_callback(callback)
    return function (result, accept)
        edit_location(accept, callback(result))
    end
end

---@type fun(root: string?, path: string): string
local function path_argument(root, path)
    return vim.fn.fnameescape(root and vim.fs.joinpath(root, path) or path)
end

---@type fun(command: string, prompt: string?, root: string?): function
local function fzf_files(command, prompt, root)
    return function()
        run_fzf({
            command   = command,
            fzfargs   = '--scheme=path',
            prompt    = prompt,
            directory = root,
            on_result = make_on_result_callback(function (result)
                return { path = path_argument(root, result) }
            end),
        })
    end
end

---@type fun(prompt: string?, root: string?): function
local function fzf_grep(prompt, root)
    local reload = 'reload(test -n \"{q}\" && rg --color=always --smart-case --line-number --column -- {q} || true)'
    return function ()
        run_fzf({
            command   = 'echo loading...',
            fzfargs   = string.format('--preview= --disabled --ansi --bind=start:"%s",change:"%s"', reload, reload),
            prompt    = prompt,
            directory = root,
            on_result = make_on_result_callback(function (result)
                local path, line, column = result:match('^([^:]+):([0-9]+):([0-9]+):')
                return { path = path_argument(root, path), line = tonumber(line), column = tonumber(column) }
            end),
        })
    end
end

local function fzf_buffer_lines()
    run_fzf({
        command   = 'nl --body-numbering=a --number-format=ln ' .. vim.fn.shellescape(vim.fn.expand('%')),
        fzfargs   = '--tac --no-sort',
        prompt    = 'Buffer',
        on_result = make_on_result_callback(function (result)
            return { line = tonumber(result:match('^[0-9]+')) }
        end),
    })
end

local function fzf_help_tags()
    local tags_files = vim.fn.globpath(vim.o.runtimepath, vim.fs.joinpath('doc', 'tags'), nil, true)
    run_fzf({
        command   = 'cat ' .. vim.iter(tags_files):map(vim.fn.shellescape):join(' '),
        fzfargs   = '--preview=',
        prompt    = 'Help',
        on_result = function (line, accept)
            local modifiers = { ['ctrl-t'] = 'tab', ['ctrl-v'] = 'vertical' }
            vim.cmd(string.format('%s help %s', modifiers[accept] or 'horizontal', line:match('^([^\t]+)')))
        end,
    })
end

local function fzf_manpages()
    run_fzf({
        command = 'apropos .',
        fzfargs = [[--preview="echo {} | awk '{print\$1\$2}' | xargs man | col --spaces --no-backspaces"]],
        prompt  = 'Manpages',
        on_result = function (line, accept)
            local name, section = line:match('^(%S+)%s+%((.*)%)')
            local modifiers = { ['ctrl-t'] = 'tab', ['ctrl-v'] = 'vertical' }
            vim.cmd(string.format('%s Man %s %s', modifiers[accept] or 'horizontal', section, name))
        end,
    })
end

local function fzf_hoogle()
    run_fzf({
        command   = 'true',
        prompt    = 'Hoogle',
        fzfargs   = '--preview= --ansi --disabled --bind=change:reload:"hoogle --count=500 {q}"',
        on_result = function () end,
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
vim.keymap.set('n', '<leader>sa',   fzf_files(allfiles, 'Home', vim.env.HOME))
vim.keymap.set('n', '<leader>sd',   fzf_files(files,    'Dotfiles', vim.env.DOTFILES))
vim.keymap.set('n', '<leader>sD',   fzf_grep('Dotfiles', vim.env.DOTFILES))
vim.keymap.set('n', '<leader>sm',   fzf_manpages)
vim.keymap.set('n', '<leader>sh',   fzf_hoogle)
vim.keymap.set('n', '<leader>r',    fzf_grep('Grep'))
vim.keymap.set('n', '<leader>?',    fzf_help_tags)
vim.keymap.set('n', '<leader>/',    fzf_buffer_lines)
vim.keymap.set('n', '<leader><bs>', fzf_resume)
