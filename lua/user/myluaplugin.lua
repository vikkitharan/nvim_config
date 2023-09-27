local status_ok, myplugin = pcall(require, "myLuaPlugin")
if not status_ok then
  print('Failed to load myLuaPlugin')
  return
end

vim.keymap.set('n', '<leader>my', myplugin.some_function, { desc = 'call some_function' })
