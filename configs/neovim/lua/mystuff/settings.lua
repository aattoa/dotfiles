vim.g.mapleader       = " "             -- Set the leader key

vim.g.netrw_banner    = 0               -- Disable the Netrw help banner
vim.g.netrw_list_hide = "^\\.\\/$"      -- Disable current directory entry

vim.opt.guicursor     = ""              -- Disable cursor styling
vim.opt.cursorline    = true            -- Highlight current line

vim.opt.number        = true            -- Enable line numbers

vim.opt.tabstop       = 4               -- Tab character width
vim.opt.expandtab     = true            -- Insert spaces in place of tabs

vim.opt.shiftwidth    = 4               -- Indentation width
vim.opt.smartindent   = true            -- Automatically indent new lines

vim.opt.ignorecase    = true            -- Enable case insensitive search
vim.opt.hlsearch      = false           -- Do not highlight search matches by default
vim.opt.incsearch     = true            -- Interactive search highlight

vim.opt.updatetime    = 100             -- Faster CursorHold events

vim.opt.undofile      = true            -- Enable persistent undo

vim.opt.wrap          = false           -- Do not wrap long lines

vim.opt.pumheight     = 10              -- Limit autocompletion suggestions

vim.opt.scrolloff     = 10              -- Vertical scrolloff
vim.opt.sidescrolloff = 20              -- Horizontal scrolloff
