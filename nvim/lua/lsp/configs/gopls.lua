local function golang_imports(client, bufnr, timeout_ms)
  if not client.supports_method('textDocument/codeAction') then
    return
  end

  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }

  local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, timeout_ms)
  if not result then return end

  local res = result[client.id]
  if not res or not res.result then return end

  local action = res.result[1]
  if not action then return end

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.

  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end

  if type(action.command) == 'table' then
    vim.lsp.buf.execute_command(action.command, client.offset_encoding)
  elseif action.command then
    vim.lsp.buf.execute_command(action, client.offset_encoding)
  end
end

local function on_attach(client, bufnr)
  vim.keymap.set('n', '\\f', function()
    golang_imports(client, bufnr, 1000)
    vim.lsp.buf.format({ async = true })
  end, { noremap = true, buffer = bufnr, desc = 'LSP: Formata o buffer atual' })

  vim.keymap.set('n', '\\I', function()
    golang_imports(client, bufnr, 1000)
  end, { noremap = true, buffer = bufnr, desc = 'LSP: Organiza os imports' })

  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   callback = function()
  --     golang_imports(client, bufnr, 1000)
  --     vim.lsp.buf.format({ async = false, })
  --   end,
  --   desc = 'LSP: Formats the buffer before write with gopls',
  -- })

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(opts)
    -- Call 'Format no_async' to not format asynchronously
    local format_opts = { async = opts.args ~= 'no_async' }
    golang_imports(client, bufnr, 1000)
    vim.lsp.buf.format(format_opts)
  end, {
    desc = 'LSP: Formata o buffer atual e organiza os imports. Format no_async pra formatar sincronamente',
    nargs = '?',
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    -- Setting async to false (no_async) because when it was set to true,
    -- I would save the buffer, it would start formatting asynchronously and
    -- then the file would be written before the formatting finishes, leaving
    -- the buffer in modified state and the written file to the disc
    -- without the changes.
    command = 'Format no_async',
    desc = 'LSP: Formats the buffer and organize imports before write with gopls '
      .. '(It uses Format no_async user command)',
  })

  -- local root_dir = client.config.root_dir
  -- if root_dir then vim.api.nvim_set_current_dir(root_dir) end
  -- vim.api.nvim_set_current_dir(root_dir)
end

return {
  cmd = { 'gopls', 'serve' },
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}
