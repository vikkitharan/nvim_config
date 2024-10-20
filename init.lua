-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' '

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
require "user.diffview"
require "user.symbols-outline"
require "user.ufo"
require "user.toggleterm"
require "user.bufferline"
require "user.rush_hdl"
require "user.search_parents"

local config_folder = os.getenv("NVIM_APPNAME")
if config_folder then
    local legacy_path = "~/.config/" .. config_folder .. "/vim/user/legacy.vim"
    vim.cmd.source(legacy_path)
else
    vim.cmd.source("~/.config/nvim/vim/user/legacy.vim")
end
