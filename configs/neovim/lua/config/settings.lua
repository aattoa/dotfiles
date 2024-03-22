vim.g.mapleader          = " "             -- Set the leader key
vim.g.man_hardwrap       = false           -- Soft-wrap manual pages
vim.g.netrw_altfile      = 1               -- Do not count the Netrw browser window as an alternate file
vim.g.netrw_banner       = 0               -- Disable the Netrw help banner
vim.g.netrw_list_hide    = "^\\.\\/$"      -- Disable the `./` directory entry
vim.g.editorconfig       = false           -- Disable unnecessary default plugin
vim.opt.modeline         = false           -- Disable unnecessary feature
vim.opt.mouse            = ""              -- Disable the mouse
vim.opt.guicursor        = ""              -- Disable cursor styling
vim.opt.signcolumn       = "no"            -- Disable the sign column
vim.opt.cursorline       = true            -- Highlight current line
vim.opt.relativenumber   = true            -- Enable relative line numbers
vim.opt.number           = true            -- Absolute line number for current line
vim.opt.tabstop          = 4               -- Tab character width
vim.opt.expandtab        = true            -- Insert spaces in place of tabs
vim.opt.shiftwidth       = 4               -- Indentation width
vim.opt.smartindent      = true            -- Automatically indent new lines
vim.opt.ignorecase       = true            -- Enable case insensitive search
vim.opt.hlsearch         = true            -- Highlight search matches
vim.opt.incsearch        = true            -- Interactive search highlight
vim.opt.updatetime       = 200             -- Faster CursorHold events
vim.opt.undofile         = true            -- Enable persistent undo
vim.opt.pumheight        = 10              -- Maximum popup menu height
vim.opt.scrolloff        = 10              -- Vertical scrolloff
vim.opt.sidescrolloff    = 30              -- Horizontal scrolloff
vim.opt.foldlevelstart   = 999             -- Start with all folds open
vim.opt.virtualedit      = "block"         -- Allow going past the end of line in visual block mode
vim.opt.splitkeep        = "topline"       -- Do not scroll when resizing horizontal splits
vim.opt.wrap             = false           -- Do not wrap long lines
vim.opt.linebreak        = true            -- Do not split words when wrapping long lines (for documentation windows)
vim.opt.conceallevel     = 2               -- Do not render markdown syntax

vim.opt.completeopt:append("noselect")     -- Do not automatically select completion entry
vim.opt.matchpairs:append("<:>")           -- Jump between matching angle brackets
vim.opt.shortmess:append("I")              -- Disable intro message
