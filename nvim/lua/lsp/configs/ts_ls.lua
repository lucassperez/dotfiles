local function organize_imports(client, bufnr, timeout_ms)
  if not client.supports_method('textDocument/codeAction') then
    return
  end

  local params = vim.lsp.util.make_range_params()
  params.context = {
    only = {
      'source.organizeImports',
      'source.addMissingImports',
    },
  }

  local result = vim.lsp.buf_request_sync(
    bufnr,
    'textDocument/codeAction',
    params,
    timeout_ms
  )

  if not result then return end

  local res = result[client.id]
  if not res or not res.result then return end

  for _, action in ipairs(res.result) do
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end

    if type(action.command) == 'table' then
      vim.lsp.buf.execute_command(action.command, client.offset_encoding)
    elseif action.command then
      vim.lsp.buf.execute_command(action, client.offset_encoding)
    end
  end
end

local function on_attach(client, bufnr)
  vim.keymap.set('n', '\\f', function()
    vim.lsp.buf.format(vim.tbl_extend('force', { bufnr = bufnr, async = true } ))
  end, { buffer = bufnr, desc = 'LSP: Formata o buffer atual' })

  vim.keymap.set('n', '\\I', function()
    organize_imports(client, bufnr, 1000)
  end, { buffer = bufnr, desc = 'LSP: Organiza os imports' })

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(opts)
    local format_opts = { async = opts.args ~= 'no_async' }
    organize_imports(client, bufnr, 1000)
    vim.lsp.buf.format(format_opts)
  end, {
    desc = 'LSP: Formata o buffer atual e organiza os imports. Format no_async pra formatar sincronamente',
    nargs = '?',
  })

  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   callback = function()
  --     format(client, bufnr, { async = false })
  --   end,
  --   desc = 'LSP: Format + imports before save',
  -- })
end

return {
  on_attach = on_attach,
}
