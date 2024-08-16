---@class ClientConfig
---@field command string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
---@field settings? table
---@field filetypes string[]
---@field root string[]

---@type table<string, ClientConfig>
return {
    kieli = {
        command = { 'kieli-language-server', '--debug' },
        filetypes = { 'kieli' },
        root = { 'build.kieli' },
    },
    clangd = {
        command = {
            'clangd',
            '--clang-tidy',                -- Enable clang-tidy checks
            '--completion-style=detailed', -- Provide individual completion entries for overloads
            '--header-insertion=never',    -- Do not automatically insert #include directives
            '--log=error',                 -- Less verbose logging
        },
        filetypes = { 'c', 'cpp' },
        root = { 'compile_commands.json' },
    },
    rust = {
        command = { 'rust-analyzer' },
        settings = {
            ['rust-analyzer'] = {
                check = {
                    command = 'clippy',
                    ignore = { 'dead_code' },
                },
                checkOnSave = { enable = true },
            },
        },
        filetypes = { 'rust' },
        root = { 'Cargo.toml', 'Cargo.lock' },
    },
    haskell = {
        command = { 'haskell-language-server-wrapper', '--lsp' },
        settings = {
            haskell = {
                plugin = {
                    stan = { globalOn = false }, -- stan mostly just gets in the way.
                },
            },
        },
        filetypes = { 'haskell' },
        root = { 'dist-newstyle' },
    },
    lua = {
        command = { 'lua-language-server' },
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                workspace = {
                    library = { vim.env.VIMRUNTIME },
                },
            },
        },
        filetypes = { 'lua' },
        root = { 'lua' },
    },
    python = {
        command = { 'pylsp' },
        settings = {
            pylsp = {
                plugins = {
                    pylint = { enabled = true },
                },
            },
        },
        filetypes = { 'python' },
        root = {},
    },
    godot = {
        command = vim.lsp.rpc.connect('127.0.0.1', 6005),
        filetypes = { 'gdscript' },
        root = { 'project.godot' },
    },
}
