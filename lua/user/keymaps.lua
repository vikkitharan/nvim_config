-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
--
local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set


keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " " --Remap space as leader key
vim.g.maplocalleader = " "


-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
vim.keymap.set('n', "<C-h>", ":TmuxNavigateLeft<CR>", { desc = 'Navigate to left' })
vim.keymap.set('n', "<C-j>", ":TmuxNavigateDown<CR>", { desc = 'Navigate to down' })
vim.keymap.set('n', "<C-k>", ":TmuxNavigateUp<CR>", { desc = 'Navigate to up' })
vim.keymap.set('n', "<C-l>", ":TmuxNavigateRight<CR>", { desc = 'Navigate to right' })
vim.keymap.set('n', "<C-\\>", ":TmuxNavigatePrevious<CR>", { desc = 'Navigate to previouw' })

keymap("n", "<leader>e", ":Lex 30<cr>", opts)


-- Resize with arrows
-- does not work in tmux
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- Insert --
-- Press jj fast to enter
vim.keymap.set('i', "jj", "<Esc>", { desc = 'switch to normal mode' })


-- Visual --
-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)


vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })


vim.keymap.set('n', '<leader>n', ":let @+=expand(\"%:p\").\":\".line('.').\":\t\".getline(\".\")<CR>", { desc = 'Copy the current file path and current line content' })
vim.keymap.set('n', ',f', ":let @+=expand(\"%:t\")<CR>", { desc = 'Copy the current line content' })
vim.keymap.set('n', ',F', ":let @+=expand(\"%:p\")<CR>", { desc = 'Copy the current file path' })
vim.keymap.set('n', ',w', ":let @+=<C-R><C-W><CR>", { desc = 'Copy the current word' })
vim.keymap.set('n', ',W', ":let @+=<C-R><C-A><CR>", { desc = 'Copy the current WORD' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


vim.cmd([[

" mappings
:nmap <Insert> i<CR><ESC>

map <F2> :mksession! ./vim_session <cr> " Quick write session with F2
map <F3> :source ./vim_session <cr>     " And load session with F3


nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

" Toggle spell checking on and off with `\s`
:nmap <silent> <leader>s :set spell!<CR>

:nnoremap <leader>w :SFiles "<C-R><C-W>"<CR>
:nnoremap <leader>W :SFiles "<C-R><C-A>"<CR>
:nnoremap <leader>bw :SBuffers "<C-R><C-W>"<CR>
:nnoremap <leader>Bw :SBuffers "<C-R><C-A>"<CR>
  ]]
)
