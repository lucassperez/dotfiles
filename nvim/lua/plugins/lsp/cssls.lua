-- CSS Language Server

-- npm i -g vscode-langservers-extracted
-- npm i -g cssmodules-language-server

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- local function on_attach(client, bufnr)
--   local map_opts = { noremap = true, buffer = bufnr }
--   vim.keymap.set('n', '\\f', function() vim.lsp.buf.format({ async = true }) end, map_opts)
--   -- vim.keymap.set('n', 'K',   function() vim.lsp.buf.definition() end, map_opts) -- I wish
--   vim.keymap.set('n', '\\k', function() vim.lsp.buf.hover() end, map_opts)
--   vim.keymap.set('n', '\\d', function() vim.diagnostic.open_float() end, map_opts)
--   vim.keymap.set('n', '[d',  function()
--     local should_center = vim.diagnostic.get_prev({ wrap = false })
--     vim.diagnostic.goto_prev({ wrap = false })
--     if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
--   end, map_opts)
--   vim.keymap.set('n', ']d',  function()
--     local should_center = vim.diagnostic.get_next({ wrap = false })
--     vim.diagnostic.goto_next({ wrap = false })
--     if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
--   end, map_opts)
--   vim.api.nvim_buf_create_user_command(bufnr, 'Format', function() vim.lsp.buf.format({ async = true }) end, { desc = 'Format current buffer with LSP', })
--   local root_dir = client.config.root_dir
--   if root_dir then vim.api.nvim_set_current_dir(root_dir) end
-- end

return {
  capabilities = capabilities,
  -- on_attach = on_attach,
  -- cmd = { 'asdf', 'shell', 'nodejs', '16.14.2', '&&', 'vscode-css-language-server', '--stdio', }
}

-- require('lspconfig').cssmodules_ls.setup({
--   on_attach = function(client, bufnr)
--     client.server_capabilities.goto_definition = false
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true, })
--   end,
--   filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'scss' }
-- })
