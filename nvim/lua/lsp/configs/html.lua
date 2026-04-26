return {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true, -- snippets are required by emmet_ls
        },
      },
    },
  },
  filetypes = {
    'html',
    'template',
  },
  -- init_options = {
  --   provideFormatter = false,
  -- },
}
