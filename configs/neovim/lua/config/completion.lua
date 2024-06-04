---@class CompletionSettings
---@field trigger_pattern string Pattern that describes autocompletion trigger characters.
---@field complete_keycode string Translated keycode sequence that triggers completion.

---@type CompletionSettings
local default_completion_settings = {
    trigger_pattern = '[_%a]',
    complete_keycode = vim.keycode('<C-x><C-n>'),
}

---@type CompletionSettings
local lsp_completion_settings = {
    trigger_pattern = '[.:_>%a]',
    complete_keycode = vim.keycode('<C-x><C-o>'),
}

---@type table<integer, CompletionSettings>
local buffer_completion_settings = {}

local function offer_completions()
    if vim.fn.pumvisible() ~= 0 or vim.fn.state('m') ~= '' then
        return -- The popup menu is already visible or we're mid-mapping.
    end
    local settings = buffer_completion_settings[vim.api.nvim_get_current_buf()] or default_completion_settings
    if vim.v.char:match(settings.trigger_pattern) then
        vim.api.nvim_feedkeys(settings.complete_keycode, 'n', false)
    end
end

---@return integer
local function autocompletion_autogroup()
    return vim.api.nvim_create_augroup('my-autocompletion', { clear = true })
end

local function start_autocomplete()
    vim.api.nvim_create_autocmd('InsertCharPre', {
        callback = offer_completions,
        group    = autocompletion_autogroup(),
        desc     = 'Autocomplete',
    })
end

local function stop_autocomplete()
    autocompletion_autogroup()
end

vim.api.nvim_create_user_command('StartAutocomplete', start_autocomplete, {})
vim.api.nvim_create_user_command('StopAutocomplete', stop_autocomplete, {})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function (event)
        buffer_completion_settings[event.buf] = lsp_completion_settings
    end,
    desc = 'Use the language server for autocompletion',
})

vim.api.nvim_create_autocmd('LspDetach', {
    callback = function (event)
        buffer_completion_settings[event.buf] = nil
    end,
    desc = 'Restore default autocompletion settings',
})

if vim.g.autocomplete then
    start_autocomplete()
end
