local function default_key_maps(bufnr)
  local map = vim.keymap.set
  local map_opts = { noremap = true, buffer = bufnr }
  map('n', '\\f', function() vim.lsp.buf.format({ async = true }) end, map_opts)
  map('n', 'K',   function() vim.lsp.buf.definition() end, map_opts)
  map('n', '\\k', function() vim.lsp.buf.hover() end, map_opts)
  map('n', '\\n', function() vim.lsp.buf.rename() end, map_opts)
  map('n', '\\r', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
      telescope.lsp_references()
    else
      print('Telescope not found, using standard neovim functions')
      vim.lsp.buf.references({})
    end
  end, map_opts)
  map('n', '\\d', function() vim.diagnostic.open_float() end, map_opts)
  map('n', '\\D', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
      telescope.diagnostics()
    else
      print('Telescope not found, using standard neovim functions')
      vim.diagnostic.open_float()
    end
  end, map_opts)
  map('n', '[d',  function()
    local should_center = vim.diagnostic.get_prev({ wrap = false })
    vim.diagnostic.goto_prev({ wrap = false })
    if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
  end, map_opts)
  map('n', ']d',  function()
    local should_center = vim.diagnostic.get_next({ wrap = false })
    vim.diagnostic.goto_next({ wrap = false })
    if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
  end, map_opts)
  map('n', '\\i', function() vim.lsp.buf.implementation() end, map_opts)
end

local function default_on_attach(client, bufnr)
  default_key_maps(bufnr)
  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
  default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities)
end

local default_handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { stylize_markdown = false, })
}

return {
  on_attach = default_on_attach,
  capabilities = default_capabilities,
  handlers = default_handlers,
  keymaps = default_key_maps,
}
