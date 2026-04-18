-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
--
-- Map .vhd extension to vhdl filetype
vim.filetype.add({
  extension = {
    vhd = 'vhdl',
  },
})
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor.
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')


  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  map('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  local lsp_format_modifications = require "lsp-format-modifications"
  lsp_format_modifications.attach(client, bufnr, { format_on_save = true })

  vim.keymap.set('n', '<leader>ti', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
  end, { buffer = bufnr, desc = 'Toggle Inlay Hints' })

  -- LSP document highlight
  local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    buffer = bufnr,
    group = group,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    buffer = bufnr,
    group = group,
    callback = vim.lsp.buf.clear_references,
  })
  -- Clean up highlights when LSP detaches
  vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
    callback = function(event)
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event.buf }
    end,
  })
end

function FormatFunction()
  vim.lsp.buf.format({
    async = true,
    range = {
      ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
      ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
    }
  })
end

vim.keymap.set('v', "<leader><leader>=", "<Esc><cmd>lua FormatFunction()<CR>", { noremap = true, desc = 'Format range' })

-- nvim-cmp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Per-server settings
local server_settings = {
  clangd = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
    },
  },
}

-- Register config for each server using the new vim.lsp.config API
for server_name, settings in pairs(server_settings) do
  vim.lsp.config(server_name, {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = settings,
  })
end

-- Ensure servers are installed and enable them
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(server_settings),
  handlers = {
    function(server_name)
      vim.lsp.enable(server_name)
    end,
  },
}
