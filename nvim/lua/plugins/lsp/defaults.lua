-- local function goToDiagnosticAndCenter(direction)
--   local should_center = vim.diagnostic['get_' .. direction]({ wrap = false })
--   vim.diagnostic['goto_' .. direction]({ wrap = false })
--   if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
-- end

local function default_key_maps(bufnr)
  local function map(lhs, rhs, command, description)
    local map_opts = { noremap = true, buffer = bufnr }
    if description then map_opts.desc = 'LSP: ' .. description end
    vim.keymap.set(lhs, rhs, command, map_opts)
  end

  local fuzzy_finder = require('plugins.FUZZY_FINDER') or {}
  local tag = string.format('%s%s', (fuzzy_finder.tag or ''), (fuzzy_finder.tag and ' ' or ''))

  local function formatDesc(desc, fun)
    return string.format('%s%s', (fun and tag or ''), desc)
  end

  map('n', '\\f', function()
    vim.lsp.buf.format({ async = true })
  end, 'Formata o buffer atual')

  map('n', 'K', function()
    if fuzzy_finder.lsp_definition then
      fuzzy_finder.lsp_definition()
    else
      vim.lsp.buf.definition()
    end
  end, formatDesc('Vai para a definição', fuzzy_finder.lsp_definition))

  map('n', '\\k', function()
    vim.lsp.buf.hover()
  end, 'Hover (documentação flutuante)')

  map('n', '\\n', function()
    vim.lsp.buf.rename()
  end, 'Renomeia')

  map('n', '\\r', function()
    if fuzzy_finder.lsp_references then
      fuzzy_finder.lsp_references()
    else
      vim.lsp.buf.references()
    end
  end, formatDesc('Mostra as referências (onde é usado)', fuzzy_finder.lsp_references))

  map('n', '\\ca', function()
    if fuzzy_finder.code_action then
      fuzzy_finder.code_action()
    else
      vim.lsp.buf.code_action()
    end
  end, formatDesc('Code action', fuzzy_finder.code_action))

  map('n', '\\d', function()
    vim.diagnostic.open_float()
  end, 'Mostra diagnóstico da linha em janela flutuante')

  map('n', '\\D', function()
    if fuzzy_finder.diagnostics then
      fuzzy_finder.diagnostics()
    else
      vim.diagnostic.open_float()
    end
  end, formatDesc('Mostra diagnósticos', fuzzy_finder.diagnostics))

  -- map('n', '[d', function()
  --   goToDiagnosticAndCenter('prev')
  -- end, 'Mostra o próximo diagnóstico do buffer')

  -- map('n', ']d', function()
  --   goToDiagnosticAndCenter('next')
  -- end, 'Mostra o diagnóstico anterior do buffer')

  map('n', '[d', function()
    vim.diagnostic.goto_prev({ wrap = false })
  end, 'Mostra o próximo diagnóstico do buffer')

  map('n', ']d', function()
    vim.diagnostic.goto_next({ wrap = false })
  end, 'Mostra o diagnóstico anterior do buffer')

  map('n', '\\i', function()
    if fuzzy_finder.lsp_implementation then
      fuzzy_finder.lsp_implementation()
    else
      vim.lsp.buf.implementation()
    end
  end, formatDesc('Mostra quem implementa', fuzzy_finder.lsp_implementation))
end

local function default_on_attach(client, bufnr)
  default_key_maps(bufnr)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'LSP: Formata o buffer atual' })

  -- local root_dir = client.config.root_dir
  -- if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities) end

-- Some specific servers calll only the keymaps and then override some
-- keymappings, which is more flexible than calling the default on_attach
-- function directly.
return {
  on_attach = default_on_attach,
  capabilities = default_capabilities,
  keymaps = default_key_maps,
}
