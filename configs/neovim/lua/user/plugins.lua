---@type fun(name: string): string
local function validate(name)
    return assert(name:match('^([a-zA-Z_-]+)$'))
end

---@class Plugin
---@field event string
---@field setup fun()
---@field loaded boolean

---@type table<string, Plugin>
local plugins = {}

---@param author string
---@param name string
---@param event string
---@param setup fun()
local function plug(author, name, event, setup)
    local path = vim.fs.joinpath(vim.fn.stdpath('data'), 'plugins', author, name) ---@diagnostic disable-line: param-type-mismatch
    if not (vim.uv or vim.loop).fs_stat(path) then ---@diagnostic disable-line: undefined-field
        local url = string.format('https://github.com/%s/%s', validate(author), validate(name))
        vim.notify(string.format('Cloning "%s"...', url))
        if vim.system({ 'git', 'clone', url, path }):wait().code ~= 0 then
            vim.notify(string.format('Failed to clone "%s"!', url), vim.log.levels.ERROR)
            return
        end
    end
    plugins[name] = { event = event, setup = setup, loaded = false }
    vim.opt.runtimepath:prepend(path)
end

plug('aattoa', 'nvim-everysig', 'VimEnter', function ()
    require('everysig').setup({ map = { mode = { 'n', 's', 'i' } } })
end)

plug('aattoa', 'nvim-simple-snippets', 'VimEnter', function ()
    require('simple-snippets').setup({
        completion = true,
        treesitter = true,
        snippets = require('user.snippets'),
    })
    vim.keymap.set('i', '<c-l>', require('simple-snippets').expand_or_jump)
    vim.keymap.set('i', '<c-space>', require('simple-snippets').complete)
end)

plug('nvim-treesitter', 'nvim-treesitter-textobjects', 'VimEnter', function ()
    -- No setup
end)

plug('nvim-treesitter', 'nvim-treesitter', 'VimEnter', function ()
    local textobject_keys = {
        f = 'function',
        a = 'parameter',
        i = 'call',
        l = 'loop',
        r = 'return',
        c = 'conditional',
    }

    local textobjects = {
        select = {
            enable    = true,
            lookahead = true,
            keymaps   = {},
        },
        move = {
            enable              = true,
            set_jumps           = false,
            goto_next_start     = {},
            goto_next_end       = {},
            goto_previous_start = {},
            goto_previous_end   = {},
        },
        swap = {
            enable        = true,
            swap_next     = { ['<leader>>'] = '@parameter.inner' },
            swap_previous = { ['<leader><'] = '@parameter.inner' },
        },
    }

    -- Create consistent mappings
    for key, name in pairs(textobject_keys) do
        local outer = '@' .. name .. '.outer'
        local inner = '@' .. name .. '.inner'

        textobjects.select.keymaps['a' .. key] = outer
        textobjects.select.keymaps['i' .. key] = inner

        textobjects.move.goto_previous_start['[' .. key:lower()] = outer
        textobjects.move.goto_previous_end  ['[' .. key:upper()] = outer
        textobjects.move.goto_next_start    [']' .. key:lower()] = outer
        textobjects.move.goto_next_end      [']' .. key:upper()] = outer
    end

    require('nvim-treesitter.configs').setup({
        ensure_installed = { 'c', 'cpp', 'rust', 'zig', 'haskell', 'ocaml', 'roc', 'lua', 'python', 'bash', 'gdscript', 'sql', 'make', 'cmake', 'json', 'toml', 'yaml', 'markdown' },
        sync_install     = false,
        auto_install     = false,
        textobjects      = textobjects,
        highlight        = { enable = true },
    })

    -- Fold with treesitter
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

    -- Repeat textobject motions
    vim.keymap.set({ 'n', 'x' }, '[[', '<cmd>TSTextobjectRepeatLastMovePrevious<cr>zz')
    vim.keymap.set({ 'n', 'x' }, ']]', '<cmd>TSTextobjectRepeatLastMoveNext<cr>zz')
    vim.keymap.set({ 'n', 'x' }, '[]', '<nop>')
    vim.keymap.set({ 'n', 'x' }, '][', '<nop>')
end)

---@param name string
local function load_plugin(name)
    if not plugins[name].loaded then
        plugins[name].setup()
        plugins[name].setup = nil
        plugins[name].loaded = true
    end
end

for name, plugin in pairs(plugins) do
    vim.api.nvim_create_autocmd(plugin.event, {
        callback = function ()
            vim.schedule(function () load_plugin(name) end)
        end,
        once = true,
        desc = 'Load plugin: ' .. name,
    })
end

local function list_plugins()
    vim.notify(vim.iter(plugins):map(function (name, plugin)
        return string.format('- %s: %s', name, plugin.loaded and 'Loaded' or 'Not loaded')
    end):join('\n'))
end

vim.api.nvim_create_user_command('Plug', function (args)
    if #args.fargs == 0 then
        list_plugins()
    else
        vim.iter(args.fargs):each(load_plugin)
    end
end, {
    nargs = '*',
    complete = function (prefix)
        return vim.tbl_filter(function (name)
            return name:sub(1, #prefix) == prefix
        end, vim.tbl_keys(plugins))
    end,
})

vim.keymap.set('n', '<leader>p', list_plugins)
