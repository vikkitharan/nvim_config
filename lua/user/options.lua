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

vim.o.showmode = true

vim.o.showtabline = 2


vim.o.cindent = true
vim.o.modeline = true
vim.o.autowrite = true

vim.o.wrap = false
vim.o.spell = false

-- Show which line your cursor is on
vim.o.cursorline = true

vim.cmd([[

:set shortmess+=|

set wildmode=longest:list
set wildignore+=*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*.swp
]]
)
