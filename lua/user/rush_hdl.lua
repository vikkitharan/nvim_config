vim.lsp.config('vhdl_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.enable('vhdl_ls')
