-- [[ Setting options ]]
-- See `:help vim.o`

vim.o.number = true -- Enable line numbers
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 250 -- After 250 ms the swap file will be written
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience

vim.o.termguicolors = true -- NOTE: You should make sure your terminal supports this


vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
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
