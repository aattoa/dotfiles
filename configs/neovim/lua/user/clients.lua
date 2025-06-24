---@class ClientConfig
---@field command string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
---@field on_attach? fun(client: vim.lsp.Client, buffer: integer): nil
---@field settings? table
---@field filetypes string[]
---@field root string[]

---@type table<string, ClientConfig>
return {
    kieli = {
        command = { 'kieli-language-server' },
        filetypes = { 'kieli' },
        root = {},
    },

    shell = {
        command = { 'shell-language-server' },
        filetypes = { 'sh', 'zsh', 'bash' },
        root = {},
    },

    clangd = {
        command = { 'clangd', '--clang-tidy', '--completion-style=detailed', '--header-insertion=never', '--log=error' },
        on_attach = function (client, buffer)
            vim.keymap.set('n', '<leader>ls', function ()
                -- https://clangd.llvm.org/extensions#switch-between-sourceheader
                local method = 'textDocument/switchSourceHeader'
                local params = vim.lsp.util.make_text_document_params(buffer)
                client:request(method, params, function (_, result)
                    if type(result) == 'string' and result ~= '' then
                        vim.api.nvim_set_current_buf(vim.uri_to_bufnr(result))
                    else
                        vim.notify('Failed to determine source/header', vim.log.levels.INFO)
                    end
                end, buffer)
            end, { buffer = buffer, desc = 'Switch source/header' })
        end,
        filetypes = { 'c', 'cpp' },
        root = { '.clangd', 'compile_commands.json' },
    },

    rust = {
        command = { 'rust-analyzer' },
        settings = {
            ['rust-analyzer'] = {
                completion = {
                    postfix = { enable = false },
                },
                check = { command = 'clippy' },
                checkOnSave = { enable = true },
            },
        },
        filetypes = { 'rust' },
        root = { 'Cargo.toml' },
    },

    zig = {
        command = { 'zls' },
        settings = {
            zls = {
                semantic_tokens = 'partial',
                enable_build_on_save = true,
            },
        },
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
                completion = {
                    callSnippet = 'Replace',
                },
                hint = {
                    enable = true,
                },
                addonManager = {
                    enable = false, -- Should be disabled by default, but just in case.
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

    tsserver = {
        command = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        root = { 'package.json', 'tsconfig.json' },
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
            vim.keymap.set('n', '<leader><leader>', function ()
                local method = 'textDocument/forwardSearch'
                local params = vim.lsp.util.make_position_params(0, 'utf-8')
                client:request(method, params, function () end, buffer)
            end, { buffer = buffer, desc = 'Forward Search' })
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
