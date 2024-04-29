-- Default background color
vim.api.nvim_set_hl(0, "Normal",      {})
vim.api.nvim_set_hl(0, "NormalFloat", {})

-- Bold active parameter in signature help popup
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bold = true })

-- Bold LSP references
vim.api.nvim_set_hl(0, "LspReferenceText",  { bold = true })
vim.api.nvim_set_hl(0, "LspReferenceRead",  { bold = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true })

-- Miscellaneous
vim.api.nvim_set_hl(0, "Constant", { fg = "NvimLightGreen" })
vim.api.nvim_set_hl(0, "SnippetTabStop", { italic = true })
