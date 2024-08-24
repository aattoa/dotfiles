local function apply_highlights()
    local cursorline = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
    vim.api.nvim_set_hl(0, 'Normal', {})
    vim.api.nvim_set_hl(0, 'NormalFloat', {})
    vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { bold = true })
    vim.api.nvim_set_hl(0, 'LspReferenceText', { bold = true, bg = cursorline.bg })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { bold = true, bg = cursorline.bg })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bold = true, bg = cursorline.bg })
    vim.api.nvim_set_hl(0, 'Constant', { link = 'String' })
    vim.api.nvim_set_hl(0, 'StatusLine', { link = 'StatusLineNC' })
    vim.api.nvim_set_hl(0, 'SnippetTabStop', { italic = true })
    vim.api.nvim_set_hl(0, 'Todo', { fg = 'DarkOrange', standout = true, bold = true })
end

vim.api.nvim_create_user_command('ApplyHighlights', apply_highlights, {})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = apply_highlights,
    desc     = 'Reapply custom highlights',
})

apply_highlights()
