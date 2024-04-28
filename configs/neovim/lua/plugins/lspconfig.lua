---@param server string
local function setup_server(server)
    require("lspconfig")[server].setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings     = require("util.lsp").server_settings,
        cmd          = require("util.lsp").server_commands[server],
    })
end

return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function ()
        require("lspconfig.ui.windows").default_options.border = "rounded"
        setup_server("clangd")
        setup_server("rust_analyzer")
        setup_server("hls")
        setup_server("pylsp")
        setup_server("lua_ls")
        setup_server("gdscript")
    end,
    lazy = false,
}
