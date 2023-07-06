-- Go Language Server

-- The golang language server gopls looks for .git or go.mod file to start

local function on_attach(client, bufnr)
  local function golangImports(timeout_ms)
    local context = { only = { 'source.organizeImports', }, }
    vim.validate({ context = { context, 't', true, }, })

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

  require('plugins.lsp.defaults').keymaps(bufnr)

  vim.keymap.set('n', '\\f', function()
    golangImports(1000)
    vim.lsp.buf.format({ async = true, })
  end, { noremap = true, buffer = bufnr, desc = 'LSP: Formata o buffer atual', })

  vim.keymap.set('n', '\\I', function() golangImports(1000) end, { noremap = true, buffer = bufnr, desc = 'LSP: Organiza os imports', })

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    callback = function()
      golangImports(1000)
      vim.lsp.buf.format({ async = false, })
    end,
  })

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    golangImports(1000)
    vim.lsp.buf.format({ async = true, })
  end, { desc = 'LSP: Formata o buffer atual e organiza os imports', })

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

return {
  cmd = { 'gopls', 'serve', },
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
