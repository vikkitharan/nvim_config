local status_ok, aerial = pcall(require, 'aerial')
if not status_ok then return end

aerial.setup({
  layout = {
    default_direction = 'right',
    width = 25,
  },
  attach_mode = 'window',
  autojump = false,
  highlight_on_hover = false,
  show_guides = true,
  keymaps = {
    ['<CR>']      = 'actions.jump',
    ['o']         = 'actions.scroll',
    ['<C-space>'] = 'actions.show_help',
    ['K']         = 'actions.toggle_preview',
    ['h']         = 'actions.tree_close',
    ['l']         = 'actions.tree_open',
    ['W']         = 'actions.tree_close_all',
    ['E']         = 'actions.tree_open_all',
    ['R']         = 'actions.tree_sync_folds',
    ['<Esc>']     = 'actions.close',
  },
})

vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle<CR>', { desc = 'Toggle [O]utline' })
