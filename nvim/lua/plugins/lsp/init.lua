-- vim.lsp.set_log_level('debug')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Ver isso depois? https://github.com/ray-x/lsp_signature.nvim

local function default_on_attach(client, bufnr)
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

-- This function mutates the first argument, it changes it! Caution!
local function mergeTables(t1, t2)
  if type(t1) == 'table' and type(t2) == 'table' then
    for k, v in pairs(t2) do
      if type(v) == 'table' and type(t1[k]) == 'table' then
        mergeTables(t1[k], v)
      else
        t1[k] = v
      end
    end
  end
  return t1
end

local function merge_handlers_with_default_handlers(handlers)
  if not handlers then return default_handlers end
  mergeTables(handlers, default_handlers)
  return handlers
end

require('plugins.fidget')
require('plugins.neodev')
require('mason').setup()

local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = { 'marksman', 'sumneko_lua', }
})

mason_lspconfig.setup_handlers({
  function(server_name)
    local ok, options = pcall(require, 'plugins.lsp.'..server_name)
    if not ok then options = {} end

    options.capabilities = options.capabilities or default_capabilities
    options.on_attach = options.on_attach or default_on_attach
    options.handlers = merge_handlers_with_default_handlers(options.handlers)

    require('lspconfig')[server_name].setup(options)
  end
})
