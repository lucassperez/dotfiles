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
  local map_opts = { noremap = true, buffer = bufnr }
  vim.keymap.set('n', '\\f',  function() vim.lsp.buf.format({ async = true }) end, map_opts)
  vim.keymap.set('n', 'K',    function() telescopeOrNvimLsp(vim.lsp.buf.definition, 'lsp_definitions') end, map_opts)
  vim.keymap.set('n', '\\k',  function() vim.lsp.buf.hover() end, map_opts)
  vim.keymap.set('n', '\\n',  function() vim.lsp.buf.rename() end, map_opts)
  vim.keymap.set('n', '\\r',  function() telescopeOrNvimLsp(vim.lsp.buf.references, 'lsp_references') end, map_opts)
  vim.keymap.set('n', '\\ca', function() vim.lsp.buf.code_action() end, map_opts)
  vim.keymap.set('n', '\\d',  function() vim.diagnostic.open_float() end, map_opts)
  vim.keymap.set('n', '\\D',  function() telescopeOrNvimLsp(vim.diagnostic.open_float, 'diagnostics') end, map_opts)
  vim.keymap.set('n', '[d',   function() goToDiagnosticAndCenter('prev') end, map_opts)
  vim.keymap.set('n', ']d',   function() goToDiagnosticAndCenter('next') end, map_opts)
  vim.keymap.set('n', '\\i',  function() telescopeOrNvimLsp(vim.lsp.buf.implementation, 'lsp_implementations') end, map_opts)
end

local function default_on_attach(client, bufnr)
  default_key_maps(bufnr)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'Format current buffer with LSP', })

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
