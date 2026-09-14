local status_ok, dap = pcall(require, 'dap')
if not status_ok then return end

local status_ui, dapui = pcall(require, 'dapui')
if not status_ui then return end

-- mason-nvim-dap auto installs debug adapters
require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = {
    'python', -- debugpy for Python
  },
}

-- Virtual text showing variable values inline
local status_vt, dapvt = pcall(require, 'nvim-dap-virtual-text')
if status_vt then
  dapvt.setup({
    display_callback = function(variable, buf, stackframe, node, options)
      return ' = ' .. variable.value
    end,
  })
end

-- DAP UI setup
dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    enabled = false,
  },
  layouts = {
    {
      elements = {
        { id = 'scopes',      size = 0.4 }, -- local variables
        { id = 'breakpoints', size = 0.2 },
        { id = 'stacks',      size = 0.2 }, -- call stack
        { id = 'watches',     size = 0.2 }, -- watch expressions
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        { id = 'repl', size = 1.0 }, -- debug console
      },
      size = 15,
      position = 'bottom',
    },
  },
}

-- Breakpoint icons
vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreak', numhl = 'DapBreak' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DapBreak', numhl = 'DapBreak' })
vim.fn.sign_define('DapBreakpointRejected', { text = '✘', texthl = 'DapBreak', numhl = 'DapBreak' })
vim.fn.sign_define('DapLogPoint', { text = '◉', texthl = 'DapBreak', numhl = 'DapBreak' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStop', linehl = 'debugPC', numhl = 'DapStop' })

-- Auto open/close UI with debug session
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config']     = dapui.close

-- GDB adapter for C/C++ (requires GDB 14+)
dap.adapters.gdb                                      = {
  type = 'executable',
  command = 'gdb',
  args = { '--interpreter=dap' },
  options = {
    disconnect_timeout_sec = 5,
  },
}

-- C/C++ configurations
dap.configurations.c                                  = {
  {
    name                            = 'Launch executable',
    type                            = 'gdb',
    request                         = 'launch',
    program                         = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd                             = function()
      return vim.fn.getcwd()
    end,
    stopAtBeginningOfMainSubprogram = true,
    externalConsole                 = false,
  },
  {
    name                            = 'Launch with args',
    type                            = 'gdb',
    request                         = 'launch',
    program                         = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args                            = function()
      local args = vim.fn.input('Arguments: ')
      return vim.split(args, ' ')
    end,
    cwd                             = function()
      return vim.fn.getcwd()
    end,
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name    = 'Attach to process',
    type    = 'gdb',
    request = 'attach',
    pid     = function()
      return vim.fn.input('PID: ')
    end,
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

-- Reuse C config for C++
dap.configurations.cpp                                = dap.configurations.c

-- Python configurations (debugpy installed via mason-nvim-dap)
dap.configurations.python                             = {
  {
    name       = 'Launch file',
    type       = 'python',
    request    = 'launch',
    program    = '${file}',
    pythonPath = function()
      return vim.fn.exepath('python3')
    end,
  },
  {
    name       = 'Launch with args',
    type       = 'python',
    request    = 'launch',
    program    = '${file}',
    args       = function()
      local args = vim.fn.input('Arguments: ')
      return vim.split(args, ' ')
    end,
    pythonPath = function()
      return vim.fn.exepath('python3')
    end,
  },
}

-- Keymaps
vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Continue' })
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<F7>', function() dapui.toggle() end, { desc = 'Debug: Toggle UI' })
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Debug: Conditional Breakpoint' })
vim.keymap.set('n', '<leader>dl', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log message: '))
end, { desc = 'Debug: Log Breakpoint' })
vim.keymap.set('n', '<leader>du', function() dapui.toggle() end, { desc = 'Debug: Toggle UI' })
vim.keymap.set('n', '<leader>dc', function() dap.run_last() end, { desc = 'Debug: Run Last' })
vim.keymap.set('n', '<leader>dx', function()
  dap.terminate()
  dapui.close()
end, { desc = 'Debug: Stop' })
vim.keymap.set('n', '<leader>dL', function() dap.list_breakpoints() end, { desc = 'Debug: List Breakpoints' })

-- Hover variable value under cursor during debug session
vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
  require('dap.ui.widgets').hover()
end, { desc = 'Debug: Hover variable' })

-- Show local variables in floating window
vim.keymap.set('n', '<leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc = 'Debug: Show scopes' })
