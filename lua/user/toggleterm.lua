local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

local function set_terminal_keymaps()
  local opts = { noremap = true, buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*toggleterm*",
  callback = function()
    set_terminal_keymaps()
  end,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
local node = Terminal:new({ cmd = "node", hidden = true })
local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })
local htop = Terminal:new({ cmd = "htop", hidden = true })
local python = Terminal:new({ cmd = "python", hidden = true })

vim.keymap.set('n', '<leader>tg', function() lazygit:toggle() end, { desc = 'Toggle Lazygit' })
vim.keymap.set('n', '<leader>tn', function() node:toggle() end, { desc = 'Toggle Node' })
vim.keymap.set('n', '<leader>tu', function() ncdu:toggle() end, { desc = 'Toggle Ncdu' })
vim.keymap.set('n', '<leader>th', function() htop:toggle() end, { desc = 'Toggle Htop' })
vim.keymap.set('n', '<leader>tp', function() python:toggle() end, { desc = 'Toggle Python' })
