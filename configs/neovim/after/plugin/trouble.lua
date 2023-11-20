require("trouble").setup {
    fold_open            = "v",
    fold_closed          = ">",
    padding              = false,
    icons                = false,
    use_diagnostic_signs = true,
}

vim.keymap.set("n", "<Leader>d", vim.cmd.TroubleToggle)
