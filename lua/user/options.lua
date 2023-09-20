-- [[ Setting options ]]
-- See `:help vim.o`

vim.wo.number = true -- Make line numbers default
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience

vim.o.termguicolors = true -- NOTE: You should make sure your terminal supports this


vim.o.incsearch = true -- helight all found matching word
vim.o.hlsearch = true -- Set highlight on search
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

--vim.o.nocompatible = true -- be iMproved, required

vim.o.encoding = "utf-8"

vim.o.wildmenu = true

vim.o.backspace = 'indent,eol,start'

vim.o.infercase = true -- Adjust case for auto complete

vim.o.ruler = true
vim.o.showcmd = true
vim.o.showmode = true

vim.o.showtabline = 2


vim.o.cindent = true
vim.o.modeline = true
vim.o.autowrite = true

vim.o.wrap = false
vim.o.spell = false

vim.o.cursorline = true

vim.cmd([[

" add current directory in path
set path+=**

:set shortmess+=|

"Disable bell sound
set belloff=all

:set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

set wildmode=longest:list
set wildignore+=*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*.swp
]]
)
