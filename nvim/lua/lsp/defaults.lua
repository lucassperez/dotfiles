local function default_key_maps(bufnr)
  local function map(lhs, rhs, command, description)
    local map_opts = { noremap = true, buffer = bufnr }
    if description then map_opts.desc = 'LSP: ' .. description end
    vim.keymap.set(lhs, rhs, command, map_opts)
  end

  local fzf = require('plugins.fzf-lua') or {}
  local tag = string.format('%s%s', (fzf.tag or ''), (fzf.tag and ' ' or ''))

  local function formatDesc(desc, fun)
    return string.format('%s%s', (fun and tag or ''), desc)
  end

  map('n', '\\f', function()
    vim.lsp.buf.format({ async = true })
  end, 'Formata o buffer atual')

  map('n', 'K', function()
    if fzf.lsp_definition then
      fzf.lsp_definition()
    else
      vim.lsp.buf.definition()
    end
  end, formatDesc('Vai para a definição', fzf.lsp_definition))

  map('n', '\\k', function()
    vim.lsp.buf.hover()
  end, 'Hover (documentação flutuante)')

  map('n', '\\n', function()
    vim.lsp.buf.rename()
  end, 'Renomeia')

  map('n', '\\r', function()
    if fzf.lsp_references then
      fzf.lsp_references()
    else
      vim.lsp.buf.references()
    end
  end, formatDesc('Mostra as referências (onde é usado)', fzf.lsp_references))

  map('n', '\\ca', function()
    if fzf.code_action then
      fzf.code_action()
    else
      vim.lsp.buf.code_action()
    end
  end, formatDesc('Code action', fzf.code_action))

  map('n', '\\d', function()
    vim.diagnostic.open_float()
  end, 'Mostra diagnóstico da linha em janela flutuante')

  map('n', '\\D', function()
    if fzf.diagnostics then
      fzf.diagnostics()
    else
      vim.diagnostic.open_float()
    end
  end, formatDesc('Mostra diagnósticos', fzf.diagnostics))

  local should_center = false
  map('n', '[d', function()
    vim.diagnostic.jump({ count = -vim.v.count1, wrap = false })
    if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
  end, 'Mostra o próximo diagnóstico do buffer')

  map('n', ']d', function()
    vim.diagnostic.jump({ count = vim.v.count1, wrap = false })
    if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
  end, 'Mostra o diagnóstico anterior do buffer')

  map('n', '\\i', function()
    if fzf.lsp_implementation then
      fzf.lsp_implementation()
    else
      vim.lsp.buf.implementation()
    end
  end, formatDesc('Mostra quem implementa', fzf.lsp_implementation))
end

local function default_on_attach(_, bufnr)
  default_key_maps(bufnr)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'LSP: Formata o buffer atual' })

  -- local root_dir = client.config.root_dir
  -- if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

local default_capabilities
local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
  default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities)
else
  default_capabilities = vim.lsp.protocol.make_client_capabilities()
end

-- Some specific servers call only the keymaps and then override some
-- keymappings, which is more flexible than calling the default on_attach
-- function directly.
return {
  on_attach = default_on_attach,
  capabilities = default_capabilities,
  -- TODO eliminar isso
  keymaps = default_key_maps,
}
