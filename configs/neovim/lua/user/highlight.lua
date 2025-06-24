local cursorline_bg = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = 'CursorLine' }).bg

---@type table<string, vim.api.keyset.highlight>
local map = {
    Normal                      = {},
    NormalFloat                 = {},
    LspSignatureActiveParameter = { bold = true },
    LspReferenceText            = { bold = true, bg = cursorline_bg },
    LspReferenceWrite           = { bold = true, bg = cursorline_bg, underline = true },
    Todo                        = { bold = true, fg = 'DarkOrange', underline = true },
    SnippetTabStop              = { italic = true },
    Constant                    = { link = 'String' },
    ['@lsp.mod.deduced.cpp']    = { link = '@type.builtin' },
    ['@markup.link']            = { bold = true },
    ['@markup.raw.block']       = {},
}

local function apply_highlights()
    for name, highlight in pairs(map) do
        vim.api.nvim_set_hl(0, name, highlight)
    end
end

vim.api.nvim_create_user_command('ApplyHighlights', apply_highlights, {})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = apply_highlights,
    desc     = 'Reapply custom highlights',
})

apply_highlights()
