-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
--
local opts = { noremap = true, silent = true }

vim.keymap.set("", "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Clear highlights on search when pressing <leader>j in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', "<leader>j", ":noh<CR>", { desc = 'Clear highlight search' })

-- change buffer
vim.keymap.set('n', "<leader>bj", ":bprevious<CR>", { desc = 'Change to the previous buffer' })
vim.keymap.set('n', "<leader>bl", ":bnext<CR>", { desc = 'Change to the next buffer' })

-- Delete current buffer without afecting the window
vim.keymap.set('n', "<leader>bd", ":bp|bd #<CR>", { desc = 'Delete current buffer without affectong the window' })

-- Toggle spelling check
vim.keymap.set('n', "<leader>sp", ":set spell!<CR>", { desc = 'Toggle spell check' })

-- Better window navigation
vim.keymap.set('n', "<C-h>", ":TmuxNavigateLeft<CR>", { desc = 'Navigate to left' })
vim.keymap.set('n', "<C-j>", ":TmuxNavigateDown<CR>", { desc = 'Navigate to down' })
vim.keymap.set('n', "<C-k>", ":TmuxNavigateUp<CR>", { desc = 'Navigate to up' })
vim.keymap.set('n', "<C-l>", ":TmuxNavigateRight<CR>", { desc = 'Navigate to right' })
vim.keymap.set('n', "<C-\\>", ":TmuxNavigatePrevious<CR>", { desc = 'Navigate to previouw' })

-- Nvimtree
vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<cr>", opts)

-- Resize with arrows
-- does not work in tmux
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- Insert --
-- Press jj fast to enter
vim.keymap.set('i', "jj", "<Esc>", { desc = 'switch to normal mode' })

-- insert at the cursor position
vim.keymap.set('n', "<Insert>", "i<CR><ESC>", { desc = 'Insert at the currsor position' })


-- Visual --
-- Move text up and down
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)
vim.keymap.set("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)



-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })



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

-- flash
vim.keymap.set({ "n", "x", "o" }, '<leader>f', function() require("flash").jump() end, { desc = 'Flash' })
vim.keymap.set({ "n", "x", "o" }, '<leader>F',function() require("flash").treesitter() end, { desc = 'Flash Treesitter' })
--[[ vim.keymap.set({"o" }, '<leader>fr',  function() require("flash").remote() end, { desc = 'Remote Flash' }) ]]
--[[ vim.keymap.set({"o", "x" }, '<leader>Fr', function() require("flash").treesitter_search() end, { desc = 'Treesitter Search' }) ]]
--[[ vim.keymap.set({"c"}, '<leader>ft', function() require("flash").toggle() end, { desc = 'Toggle Flash Search' }) ]]


vim.cmd([[

map <F2> :mksession! ./vim_session <cr> " Quick write session with F2
map <F3> :source ./vim_session <cr>     " And load session with F3

:nnoremap <leader>w :SFiles "<C-R><C-W>"<CR>
:nnoremap <leader>W :SFiles "<C-R><C-A>"<CR>
:nnoremap <leader>bw :SBuffers "<C-R><C-W>"<CR>
:nnoremap <leader>Bw :SBuffers "<C-R><C-A>"<CR>
  ]]
)
