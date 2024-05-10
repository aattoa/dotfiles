function APPLY_HIGHLIGHTS()
    local cursorline = vim.api.nvim_get_hl(0, { name = "CursorLine" })

    -- Default background color
    vim.api.nvim_set_hl(0, "Normal",      {})
    vim.api.nvim_set_hl(0, "NormalFloat", {})

    -- Bold active parameter in signature help popup
    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bold = true })

    -- LSP references
    vim.api.nvim_set_hl(0, "LspReferenceText",  { bold = true, bg = cursorline.bg })
    vim.api.nvim_set_hl(0, "LspReferenceRead",  { bold = true, bg = cursorline.bg })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, bg = cursorline.bg })

    -- Miscellaneous
    vim.api.nvim_set_hl(0, "Constant", { link = "String" })
    vim.api.nvim_set_hl(0, "StatusLine", { link = "StatusLineNC" })
    vim.api.nvim_set_hl(0, "SnippetTabStop", { italic = true })

    -- TODOs stand out
    vim.api.nvim_set_hl(0, "Todo", { fg = "DarkOrange", standout = true, bold = true })
end

APPLY_HIGHLIGHTS()
