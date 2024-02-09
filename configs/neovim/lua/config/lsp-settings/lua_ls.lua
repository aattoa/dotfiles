return {
    Lua = {
        runtime     = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace   = { library = { vim.env.VIMRUNTIME } },
    },
}
