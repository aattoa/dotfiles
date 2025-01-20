vim.g.mapleader          = ' '                -- Set the leader key
vim.g.man_hardwrap       = false              -- Soft-wrap manual pages
vim.g.netrw_altfile      = 1                  -- Do not count the Netrw browser window as an alternate file
vim.g.netrw_banner       = 0                  -- Disable the Netrw help banner
vim.g.netrw_dirhistmax   = 0                  -- Disable Netrw directory history
vim.g.netrw_cursor       = 5                  -- Make Netrw respect cursorline and cursorcolumn
vim.g.netrw_list_hide    = '^\\.\\+\\/$'      -- Disable directory entries ./ and ../
vim.g.floatborder        = 'single'           -- Border for all floating windows (not a built in global)
vim.opt.modeline         = false              -- Disable unnecessary feature
vim.opt.mouse            = ''                 -- Disable the mouse
vim.opt.guicursor        = ''                 -- Disable cursor styling
vim.opt.signcolumn       = 'no'               -- Disable the sign column
vim.opt.cursorline       = false              -- Highlight current line
vim.opt.relativenumber   = true               -- Enable relative line numbers
vim.opt.number           = true               -- Absolute line number for current line
vim.opt.smartindent      = true               -- Automatically indent new lines
vim.opt.ignorecase       = true               -- Enable case insensitive search
vim.opt.smartcase        = true               -- Case sensitive search when not all lowercase
vim.opt.hlsearch         = true               -- Highlight search matches
vim.opt.incsearch        = true               -- Interactive search highlight
vim.opt.updatetime       = 200                -- Faster CursorHold events
vim.opt.ttimeoutlen      = 10                 -- Smaller time window for keycodes
vim.opt.undofile         = true               -- Enable persistent undo
vim.opt.expandtab        = true               -- Insert spaces in place of tabs
vim.opt.tabstop          = 4                  -- Tab character width
vim.opt.shiftwidth       = 0                  -- Use tabstop value for indentation
vim.opt.list             = true               -- Render whitespace according to listchars
vim.opt.listchars        = 'tab:| ,trail:_'   -- Whitespace rendering settings
vim.opt.pumheight        = 10                 -- Maximum popup menu height
vim.opt.cmdwinheight     = 14                 -- Bigger command-line window
vim.opt.scrolloff        = 10                 -- Vertical scrolloff
vim.opt.sidescrolloff    = 40                 -- Horizontal scrolloff
vim.opt.foldenable       = false              -- Do not fold by default
vim.opt.foldlevelstart   = 999                -- Start with all folds open
vim.opt.sessionoptions   = 'tabpages,winsize' -- What to save in session files
vim.opt.virtualedit      = 'block'            -- Allow going past the end of line in visual block mode
vim.opt.jumpoptions      = 'stack'            -- Better jumplist behavior
vim.opt.showmode         = false              -- Do not show current mode
vim.opt.wrap             = false              -- Do not wrap long lines
vim.opt.wrapscan         = false              -- Do not wrap searches around the end of file
vim.opt.linebreak        = true               -- Do not split words when wrapping long lines (for documentation windows)
vim.opt.cinoptions       = ':0'               -- Do not further indent case labels

-- Jump between matching angle brackets with %
vim.opt.matchpairs:append('<:>')

-- Disable the intro message
vim.opt.shortmess:append('I')

-- Disable insert mode completion messages
vim.opt.shortmess:append('c')

-- Recursively `:find` in subdirectories
vim.opt.path:append('**')

-- Do not scroll when resizing horizontal splits
if vim.fn.exists('&splitkeep') == 1 then
    vim.opt.splitkeep = 'topline'
end

vim.opt.wildoptions = { 'pum', 'fuzzy' }
vim.opt.completeopt = { 'menuone', 'noselect' }
if vim.fn.has('nvim-0.10') == 1 then
    vim.opt.completeopt:append('popup')
end
if vim.fn.has('nvim-0.11') == 1 then
    vim.opt.completeopt:append('fuzzy')
end

vim.diagnostic.config({
    float = {
        border = vim.g.floatborder,
        header = '',
        source = true,
    },
    severity_sort = true,
    update_in_insert = true,
})

-- Disable regex-based syntax highlighting
vim.cmd.syntax('off')

-- Disable some cruft
vim.g.editorconfig = false
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.opt.runtimepath:remove('/usr/lib/nvim')
vim.opt.runtimepath:remove('/etc/xdg/nvim')
vim.opt.runtimepath:remove('/etc/xdg/nvim/after')
vim.opt.runtimepath:remove('/usr/share/vim/vimfiles')
vim.opt.runtimepath:remove('/usr/share/vim/vimfiles/after')
vim.opt.runtimepath:remove('/usr/share/nvim/site')
vim.opt.runtimepath:remove('/usr/share/nvim/site/after')
vim.opt.runtimepath:remove('/usr/local/share/nvim/site')
vim.opt.runtimepath:remove('/usr/local/share/nvim/site/after')
