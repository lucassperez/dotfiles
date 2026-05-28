return {
  init_options = {
    addonSettings = {
      ['Ruby LSP Rails'] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end
}
