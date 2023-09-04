-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true


-- from Vikki's vimrc

-- helight all found matching word
vim.o.incsearch = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.cmd([[

set nocompatible              " be iMproved, required


set encoding=utf-8

" split windows vertically when termdebug is intitiated
let g:termdebug_wide=1

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

:syntax enable

" add current directory in path
set path+=**

set wildmenu

:set backspace=indent,eol,start

"Adjust case for auto complete
:set infercase

:set ruler showcmd showmode
:set shortmess+=|

"Disable bell sound
set belloff=all

:set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words


:set showtabline=2

:set cindent
:set modeline
:set autowrite

:set nowrap
:set nospell


:set foldmethod=manual

set wildmenu
set wildmode=longest:list
set wildignore+=*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*.swp
]]
)
