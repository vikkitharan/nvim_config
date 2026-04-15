local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

gitsigns.setup {
  signs = {
    add          = { text = '┃+' },
    change       = { text = '┃~' },
    delete       = { text = '┃_' },
    topdelete    = { text = '┃‾' },
    changedelete = { text = '┃!' },
    untracked    = { text = '┃┆' },
  },
  signs_staged = {
    add          = { text = '┃+' },
    change       = { text = '┃~' },
    delete       = { text = '┃_' },
    topdelete    = { text = '┃‾' },
    changedelete = { text = '┃!' },
    untracked    = { text = '┆' },
  },
 signs_staged_enable = true,
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}

-- Navigation
vim.keymap.set('n', ']h', function() require('gitsigns').nav_hunk('next') end, { desc = 'Next git hunk' })
vim.keymap.set('n', '[h', function() require('gitsigns').nav_hunk('prev') end, { desc = 'Previous git hunk' })

-- Actions
vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { desc = 'Reset hunk' })
vim.keymap.set('v', '<leader>hs', function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Stage hunk' })
vim.keymap.set('v', '<leader>hr', function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>hS', require('gitsigns').stage_buffer, { desc = 'Stage buffer' })
vim.keymap.set('n', '<leader>hR', require('gitsigns').reset_buffer, { desc = 'Reset buffer' })
vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>hb', require('gitsigns').blame_line, { desc = 'Blame line' })
vim.keymap.set('n', '<leader>hd', require('gitsigns').diffthis, { desc = 'Diff this' })
vim.keymap.set('n', '<leader>tb', require('gitsigns').toggle_current_line_blame, { desc = 'Toggle line blame' })
vim.keymap.set('n', '<leader>tw', require('gitsigns').toggle_word_diff, { desc = 'Toggle word diff' })
