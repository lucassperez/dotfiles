-- Typescript Language Server

-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c

-- npm i -g typescript-language-server
-- Também tem que ter o próprio typescript instalado, tipo com npm i -g typescript
-- Também deveria instalar o eslint_d com npm i -g eslint_d

local on_attach = function(client, bufnr)
  local map = vim.keymap.set

  local map_opts = { noremap = true, buffer = bufnr }

  map('n', '\\f', function()
    vim.cmd.TSLspImportAll()
    vim.cmd.TSLspOrganize()
    vim.lsp.buf.format({ async = true })
  end, map_opts)

  map('n', 'K',   function() vim.lsp.buf.definition() end, map_opts)
  map('n', '\\k', function() vim.lsp.buf.hover() end, map_opts)
  map('n', '\\n', function() vim.lsp.buf.rename() end, map_opts)
  map('n', '\\r', function() require('telescope.builtin').lsp_references() end, map_opts)
  map('n', '\\d', function() vim.diagnostic.open_float() end, map_opts)
  map('n', '[d',  function() vim.diagnostic.goto_prev(); vim.api.nvim_feedkeys('zz', 'n', false) end, map_opts)
  map('n', ']d',  function() vim.diagnostic.goto_next(); vim.api.nvim_feedkeys('zz', 'n', false) end, map_opts)
  map('n', '\\i', function() vim.lsp.buf.implementation() end, map_opts)

  map('n', '\\I', function()
    vim.cmd.TSLspImportAll()
    vim.cmd.TSLspOrganize()
  end, map_opts)

  -- map('n', '\\f', function()
  --   vim.cmd.TSLspImportAll()
  --   vim.cmd.TSLspOrganize()
  --   vim.lsp.buf.format({ async = true })
  -- end, map_opts)

  -- vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.format()')

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    -- null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.formatting.prettier
  },
  on_attach = on_attach
})

return {
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    local ts_utils = require('nvim-lsp-ts-utils')
    ts_utils.setup({
      -- eslint_bin = 'eslint_d',
      -- eslint_enable_diagnostics = false,
      -- eslint_enable_code_actions = false,
      -- enable_formatting = true,
      -- formatter = 'prettier',
    })
    ts_utils.setup_client(client)

    on_attach(client, bufnr)
  end,
}
