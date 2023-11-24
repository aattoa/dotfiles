return {
    "williamboman/mason.nvim",
    opts = {
        ui = {
            icons = {
                package_installed   = "✓",
                package_pending     = "➜",
                package_uninstalled = "✗",
            },
            keymaps = {
                update_package      = "r",
                update_all_packages = "R",
                uninstall_package   = "u",
                toggle_help         = "?",
            },
            border = "double",
        }
    },
    keys = {{ "<Leader>ll", "<Cmd>Mason<Return>" }},
}
