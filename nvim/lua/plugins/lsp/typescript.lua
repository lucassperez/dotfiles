-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c

-- npm i -g typescript-language-server
-- Também tem que ter o próprio typescript instalado, tipo com npm i -g typescript
-- Também deveria instalar o eslint_d com npm i -g eslint_d

local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local map_opts = { noremap = true, silent = true }

  map('n', [[\f]], ':lua vim.lsp.buf.format({async=true})<CR>', map_opts)
  -- map('n', [[\f]], ':TSLspImportAll<CR>:TSLspOrganize<CR>:lua vim.lsp.buf.format({async=true})<CR>', map_opts)
  map('n', 'K',    ':lua vim.lsp.buf.definition()<CR>', map_opts)
  map('n', [[\k]], ':lua vim.lsp.buf.hover()<CR>', map_opts)
  -- map('n', [[\K]], ':lua vim.lsp.buf.signature_help()<CR>', map_opts)
  map('n', [[\n]], ':lua vim.lsp.buf.rename()<CR>', map_opts)
  map('n', [[\r]], ':lua vim.lsp.buf.references()<CR>', map_opts)
  map('n', '[d',   ':lua vim.diagnostic.goto_prev()<CR>', map_opts)
  map('n', ']d',   ':lua vim.diagnostic.goto_next()<CR>', map_opts)
  map('n', [[\d]], ':lua vim.diagnostic.open_float()<CR>', map_opts)

  map('n', [[\i]], ':TSLspImportAll<CR>:TSLspOrganize<CR>', map_opts)
  map('n', [[\I]], ':lua vim.lsp.buf.implementation()<CR>', map_opts)

  -- vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.format()')

  -- Fica feio, porque a quickfix vem junto com o nome dos arquivos, e daí
  -- não dá pra ler o nome dos arquivos. Mas eu adoraria conseguir usar o
  -- telescope pra isso.
  -- map('n', [[\r]], ':lua require("telescope.builtin").lsp_references()<CR>', map_opts)

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

lspconfig.tsserver.setup({
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
})

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
