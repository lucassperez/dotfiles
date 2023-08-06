local function telescopeOrNvimLsp(std_function, telescope_function_name)
  local ok, telescope = pcall(require, 'telescope.builtin')
  if ok then
    if telescope[telescope_function_name] then
      telescope[telescope_function_name]()
    else
      print('Telescope function `' .. telescope_function_name ..'` not found, using standard neovim functions')
      std_function()
    end
  else
    print('Telescope not found, using standard neovim functions')
    std_function()
  end
end

local function goToDiagnosticAndCenter(direction)
  local should_center = vim.diagnostic['get_'..direction]({ wrap = false })
  vim.diagnostic['goto_'..direction]({ wrap = false })
  if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
end

local function default_key_maps(bufnr)
  local function map(lhs, rhs, command, description)
    local map_opts = { noremap = true, buffer = bufnr, }
    if description then map_opts.desc = 'LSP: ' .. description end
    vim.keymap.set(lhs, rhs, command, map_opts)
  end

  map('n', '\\f',  function() vim.lsp.buf.format({ async = true }) end, 'Formata o buffer atual')
  map('n', 'K',    function() telescopeOrNvimLsp(vim.lsp.buf.definition, 'lsp_definitions') end, 'Vai para a definição (telescope se possível)')
  map('n', '\\k',  function() vim.lsp.buf.hover() end, 'Hover (documentação flutuante)')
  map('n', '\\n',  function() vim.lsp.buf.rename() end, 'Renomeia')
  map('n', '\\r',  function() telescopeOrNvimLsp(vim.lsp.buf.references, 'lsp_references') end, 'Mostra as referências (onde é usado) (telescope se possível)')
  map('n', '\\ca', function() vim.lsp.buf.code_action() end, 'Code action')
  map('n', '\\d',  function() vim.diagnostic.open_float() end, 'Mostra diagnóstico da linha em janela flutuante')
  map('n', '\\D',  function() telescopeOrNvimLsp(vim.diagnostic.open_float, 'diagnostics') end, 'Mostra diagnósticos com telescope se possível')
  map('n', '[d',   function() goToDiagnosticAndCenter('prev') end, 'Mostra o próximo diagnóstico do buffer')
  map('n', ']d',   function() goToDiagnosticAndCenter('next') end, 'Mostra o diagnóstico anterior do buffer')
  map('n', '\\i',  function() telescopeOrNvimLsp(vim.lsp.buf.implementation, 'lsp_implementations') end, 'Mostra quem implementa (telescope se possível)')
end

local function default_on_attach(client, bufnr)
  default_key_maps(bufnr)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'LSP: Formata o buffer atual', })

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
  default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities)
end

-- Some specific servers calll only the keymaps and then override some
-- keymappings, which is more flexible than calling the default on_attach
-- function directly.
return {
  on_attach = default_on_attach,
  capabilities = default_capabilities,
  keymaps = default_key_maps,
}
