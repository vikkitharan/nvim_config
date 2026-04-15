local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then return end

bufferline.setup({
  options = {
    numbers = "none",
    close_command = "Bdelete! %d",
    right_mouse_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    indicator = {
      style = "icon",
      icon = "▎",
    },
    buffer_close_icon = "󰅖",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      },
    },
    show_buffer_close_icons = true,
    show_close_icon = true,
    separator_style = "thin",
    always_show_bufferline = true,
  },
})
