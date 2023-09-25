vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' '

-- nvim-tree: disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require "user.plugins"
require "user.options"
require "user.keymaps"
require "user.commands"
require "user.lsp"
require "user.treesitter"
require "user.cmp"
require "user.telescope"
require "user.gitsigns"
require "user.nvim-tree"
require "user.comment"
require "user.autopairs"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
