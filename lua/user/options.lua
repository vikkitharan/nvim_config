-- [[ Setting options ]]
-- See `:help vim.o`

-- Make line numbers default
vim.o.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.

-- Enable break indent
vim.o.breakindent = true

 -- Save undo history
vim.o.undofile = true

 -- After 250 ms the swap file will be written
vim.o.updatetime = 250

-- Displays which-key popup sooner
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience

vim.o.termguicolors = true -- NOTE: You should make sure your terminal supports this

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.infercase = true -- Adjust case for auto complete

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

vim.o.showtabline = 2


vim.o.cindent = true
vim.o.modeline = true
vim.o.autowrite = true

vim.o.wrap = false
vim.o.spell = false

-- Show which line your cursor is on
vim.o.cursorline = true

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

vim.cmd([[

syntax on

:set shortmess+=|

set wildmode=longest:list
set wildignore+=*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*.swp
]]
)

if vim.opt.diff:get() then
  vim.cmd.colorscheme 'pablo'
end

