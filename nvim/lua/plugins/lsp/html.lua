local capabilities = require('plugins.lsp.defaults').capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  capabilities = capabilities,
  filetypes = {
    'html',
    'template',
  },
  -- init_options = {
  --   provideFormatter = false,
  -- },
}
