-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 100 --[[milliseconds]] }) end,
})

-- Automatically update plugins when plugins.lua is updated
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

-- Format C++ files automatically
-- https://vi.stackexchange.com/questions/21102/how-to-clang-format-the-current-buffer-on-save
vim.cmd([[
    function FormatBuffer()
        if &modified && !empty(findfile(".clang-format", expand("%:p:h") . ";"))
            let cursor_pos = getpos(".")
            :%!clang-format
            call setpos(".", cursor_pos)
        endif
    endfunction
    autocmd BufWritePre *.hpp,*.cpp :call FormatBuffer()
]])
