---@class ClientConfig
---@field command string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
---@field on_attach? fun(client: vim.lsp.Client, buffer: integer): nil
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
        command = { 'clangd', '--clang-tidy', '--completion-style=detailed', '--header-insertion=never', '--log=error' },
        filetypes = { 'c', 'cpp' },
        root = { '.clangd', 'compile_commands.json' },
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

    zig = {
        command = { 'zls' },
        filetypes = { 'zig' },
        root = { 'build.zig' },
    },

    haskell = {
        command = { 'haskell-language-server-wrapper', '--lsp' },
        filetypes = { 'haskell' },
        root = { 'cabal.project', 'dist-newstyle' },
    },

    ocaml = {
        command = { 'opam', 'exec', 'ocamllsp' },
        filetypes = { 'ocaml' },
        root = { 'dune-project' },
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
        -- Godot uses port 6005 for LSP: https://docs.godotengine.org/en/stable/tutorials/editor/external_editor.html#lsp-dap-support
        command = vim.lsp.rpc.connect('127.0.0.1', 6005),
        filetypes = { 'gdscript' },
        root = { 'project.godot' },
    },

    latex = {
        command = { 'texlab' },
        on_attach = function (client, buffer)
            local function fwd()
                client.request('textDocument/forwardSearch', vim.lsp.util.make_position_params(), function () end, buffer)
            end
            vim.keymap.set('n', '<leader><leader>', fwd, { buffer = buffer, desc = 'Forward Search' })
        end,
        settings = {
            texlab = {
                build = {
                    onSave = true,
                    executable = 'latexmk',
                    args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                },
                chktex = {
                    onEdit = true,
                    onOpenAndSave = true,
                },
                forwardSearch = {
                    executable = 'zathura',
                    args = { '--synctex-forward', '%l:1:%f', '%p' },
                },
                diagnosticsDelay = 100,
            },
        },
        filetypes = { 'tex', 'plaintex' },
        root = {},
    },
}
