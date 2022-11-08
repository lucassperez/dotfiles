-- npm i -g vscode-langservers-extracted
-- npm i -g cssmodules-language-server

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function cssls_on_attach(client, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = { noremap = true, silent = true }
  -- map('n', 'K',    ':lua vim.lsp.buf.definition()<CR>', map_opts) -- I wish
  map('n', [[\f]], ':lua vim.lsp.buf.format({async=true})<CR>', map_opts)
  map('n', [[\k]], ':lua vim.lsp.buf.hover()<CR>', map_opts)
  map('n', '[d',   ':lua vim.diagnostic.goto_prev()<CR>', map_opts)
  map('n', ']d',   ':lua vim.diagnostic.goto_next()<CR>', map_opts)
  map('n', [[\d]], ':lua vim.diagnostic.open_float()<CR>', map_opts)

  vim.api.nvim_set_current_dir(client.config.root_dir)
end

require('lspconfig').cssls.setup({
  capabilities = capabilities,
  on_attach = cssls_on_attach,
  -- cmd = { 'asdf', 'shell', 'nodejs', '16.14.2', '&&', 'vscode-css-language-server', '--stdio', }
})

-- require('lspconfig').cssmodules_ls.setup({
--   on_attach = function(client, bufnr)
--     client.server_capabilities.goto_definition = false
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true, })
--   end,
--   filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'scss' }
-- })
