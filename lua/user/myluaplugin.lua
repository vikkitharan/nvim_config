vim.api.nvim_command('set rtp+=/home/vikki/trial/luaPlugin/')

vim.api.nvim_create_user_command("Test",
  function ()
  package.loaded.myLuaPlugin = nil
  require("myLuaPlugin").some_function()
end, {})
