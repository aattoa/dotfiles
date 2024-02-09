return {
    pylsp = {
        plugins = {
            pylsp_mypy = { enabled = true }, -- type checker
            pylint     = { enabled = true }, -- linter
            black      = { enabled = true }, -- formatter
        },
    },
}
