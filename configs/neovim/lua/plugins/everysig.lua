return {
    dir = vim.fn.stdpath('data') .. '/local-plugins/nvim-everysig',
    opts = {
        override = true,
        silent   = true,
        number   = true,
    },
    event = 'LspAttach',
}
