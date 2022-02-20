function golangImports(timeout_ms)
  local context = { only = { 'source.organizeImports' } }
  vim.validate { context = { context, 't', true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  -- See the implementation of the textDocument/codeAction callback
  -- (lua/vim/lsp/handler.lua) for how to do this properly.
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
  if not result or next(result) == nil then return end
  local actions = result[1].result
  if not actions then return end
  local action = actions[1]

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.
  if action.edit or type(action.command) == 'table' then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == 'table' then
      vim.lsp.buf.execute_command(action.command)
    end
  else
    vim.lsp.buf.execute_command(action)
  end
end

-- vim.api.nvim_command('autocmd BufWritePre *.go lua golangImports(1000)')

function on_attach(_, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = { noremap = true, silent = true }
  map('n', [[\f]],    ':lua vim.lsp.buf.formatting()<CR>', map_opts)
  -- map('n', [[\f]],    ':lua vim.lsp.buf.formatting()<CR>:%s/\t/  /g<CR>:noh<CR>', map_opts)
  -- map('n', [[\f]],    ':lua golangImports(1000)<CR>:lua vim.lsp.buf.formatting()<CR>:%s/\t/  /g<CR>:noh<CR>', map_opts)
  map('n', [[\f]],    ':lua golangImports(1000)<CR>:lua vim.lsp.buf.formatting()<CR>', map_opts)
  map('n', [[\i]],    ':lua golangImports(1000)<CR>', map_opts)
  map('n', 'K',    ':lua vim.lsp.buf.definition()<CR>', map_opts)
  map('n', [[\k]],     ':lua vim.lsp.buf.hover()<CR>', map_opts)
  map('n', [[\K]], ':lua vim.lsp.buf.signature_help()<CR>', map_opts)
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

