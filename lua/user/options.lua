-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- After 250 ms the swap file will be written
vim.opt.updatetime = 250

-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Adjust case for auto complete
vim.opt.infercase = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- bufferline handles the tabline, hide native tabline
vim.opt.showtabline = 0

vim.opt.cindent = true

-- Disable modelines for security
vim.opt.modeline = false

vim.opt.autowrite = true
vim.opt.wrap = false
vim.opt.spell = false

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Wildmenu completion
vim.opt.wildmode = 'longest:list'
vim.opt.wildignore:append({
  '*.o',
  '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
  '.DS_Store', '.git', '.hg', '.svn',
  '*.swp',
})

-- Shorten messages
vim.cmd('set shortmess+=|')

if vim.opt.diff:get() then
  vim.cmd.colorscheme 'pablo'
end
