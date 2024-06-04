vim.g.mapleader          = ' '                -- Set the leader key
vim.g.man_hardwrap       = false              -- Soft-wrap manual pages
vim.g.netrw_altfile      = 1                  -- Do not count the Netrw browser window as an alternate file
vim.g.netrw_banner       = 0                  -- Disable the Netrw help banner
vim.g.netrw_list_hide    = '^\\.\\/$'         -- Disable the `./` directory entry
vim.g.floatborder        = 'rounded'          -- Border for all floating windows (not a built in global)
vim.g.autocomplete       = true               -- Enable autocompletion (not a built in global)
vim.opt.modeline         = false              -- Disable unnecessary feature
vim.opt.mouse            = ''                 -- Disable the mouse
vim.opt.guicursor        = ''                 -- Disable cursor styling
vim.opt.signcolumn       = 'no'               -- Disable the sign column
vim.opt.cursorline       = true               -- Highlight current line
vim.opt.relativenumber   = true               -- Enable relative line numbers
vim.opt.number           = true               -- Absolute line number for current line
vim.opt.smartindent      = true               -- Automatically indent new lines
vim.opt.ignorecase       = true               -- Enable case insensitive search
vim.opt.hlsearch         = true               -- Highlight search matches
vim.opt.incsearch        = true               -- Interactive search highlight
vim.opt.updatetime       = 200                -- Faster CursorHold events
vim.opt.ttimeoutlen      = 10                 -- Smaller time window for keycodes
vim.opt.undofile         = true               -- Enable persistent undo
vim.opt.expandtab        = true               -- Insert spaces in place of tabs
vim.opt.tabstop          = 4                  -- Tab character width
vim.opt.shiftwidth       = 4                  -- Indentation width
vim.opt.list             = true               -- Render whitespace according to listchars
vim.opt.listchars        = 'tab:| ,trail:_'   -- Render tabs as '|   ' and trailing whitespace as '_'
vim.opt.pumheight        = 10                 -- Maximum popup menu height
vim.opt.cmdwinheight     = 14                 -- Bigger command-line window
vim.opt.scrolloff        = 10                 -- Vertical scrolloff
vim.opt.sidescrolloff    = 40                 -- Horizontal scrolloff
vim.opt.foldenable       = false              -- Do not fold by default
vim.opt.foldlevelstart   = 999                -- Start with all folds open
vim.opt.sessionoptions   = 'tabpages,winsize' -- What to save in session files
vim.opt.virtualedit      = 'block'            -- Allow going past the end of line in visual block mode
vim.opt.jumpoptions      = 'stack'            -- Better jumplist behavior
vim.opt.splitkeep        = 'topline'          -- Do not scroll when resizing horizontal splits
vim.opt.showmode         = false              -- Do not show current mode
vim.opt.wrap             = false              -- Do not wrap long lines
vim.opt.wrapscan         = false              -- Do not wrap searches around the end of file
vim.opt.linebreak        = true               -- Do not split words when wrapping long lines (for documentation windows)

-- Jump between matching angle brackets with %
vim.opt.matchpairs:append('<:>')

-- Disable the intro message
vim.opt.shortmess:append('I')

-- Disable insert mode completion messages
vim.opt.shortmess:append('c')

-- Recursively `:find` in subdirectories
vim.opt.path:append('**')

-- Completion options
vim.opt.completeopt = { 'menuone', 'noselect' }

if vim.version().minor >= 10 then
    vim.opt.completeopt:append('popup')
end
