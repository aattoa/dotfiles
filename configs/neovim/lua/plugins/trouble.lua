return {
    "folke/trouble.nvim",
    opts = {
        fold_open            = "v",
        fold_closed          = ">",
        padding              = false,
        icons                = false,
        use_diagnostic_signs = true,
    },
    keys = {{ "<Leader>d", "<Cmd>TroubleToggle<Return>" }}
}
