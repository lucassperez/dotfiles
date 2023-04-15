local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  -- on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    'eruby',
    'html',
    'css',
    'javascript',
    'javascriptreact',
    'typescriptreact',
    'less',
    'sass',
    'scss',
    'svelte',
    'pug',
    'vue'
  },
  init_options = {
    html = {
      options = {
        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        ['bem.enabled'] = true,
      },
    },
  }
}
