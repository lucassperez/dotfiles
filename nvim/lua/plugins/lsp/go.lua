function golangImports(timeout_ms)
  local context = { only = { 'source.organizeImports' } }
  vim.validate { context = { context, 't', true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
  if not result then return end
  local client_id, result = next(result)
  if not client_id then return end
  local client = vim.lsp.get_client_by_id(client_id)
  if not client then return end
  local actions = result.result
  if not actions then return end
  local action = actions[1]

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.
  if action.edit or type(action.command) == 'table' then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
    if type(action.command) == 'table' then
      vim.lsp.buf.execute_command(action.command, client.offset_encoding)
    end
  else
    vim.lsp.buf.execute_command(action, client.offset_encoding)
  end
end

-- vim.api.nvim_command('autocmd BufWritePre *.go lua golangImports(1000)')

local function on_attach(_, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local map_opts = { noremap = true, silent = true }

  -- ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
  -- ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}),
  map('n', [[\f]],    ':lua vim.lsp.buf.formatting()<CR>', map_opts)
  -- map('n', [[\f]],    ':lua vim.lsp.buf.formatting()<CR>:%s/\t/  /g<CR>:noh<CR>', map_opts)
  -- map('n', [[\f]],    ':lua golangImports(1000)<CR>:lua vim.lsp.buf.formatting()<CR>:%s/\t/  /g<CR>:noh<CR>', map_opts)
  map('n', [[\f]],    ':lua golangImports(1000)<CR>:lua vim.lsp.buf.formatting()<CR>', map_opts)
  map('n', [[\i]],    ':lua golangImports(1000)<CR>', map_opts)
  map('n', 'K',    ':lua vim.lsp.buf.definition()<CR>', map_opts)
  map('n', [[\k]],     ':lua vim.lsp.buf.hover()<CR>', map_opts)
  map('n', [[\K]], ':lua vim.lsp.buf.signature_help()<CR>', map_opts)
  map('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', map_opts)
  map('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', map_opts)
  map('n', [[\d]], ':lua vim.diagnostic.open_float()<CR>', map_opts)
end

require('lspconfig').gopls.setup({
  cmd = {'gopls', 'serve'},
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})
