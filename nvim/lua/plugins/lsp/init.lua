-- vim.lsp.set_log_level('debug')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Ver isso depois? https://github.com/ray-x/lsp_signature.nvim

local defaults = require('plugins.lsp.defaults')
local default_on_attach = defaults.on_attach
local default_capabilities = defaults.capabilities
local default_handlers = defaults.handlers

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
    local ok, options = pcall(require, 'plugins.lsp.' .. server_name)
    if not ok then options = {} end

    options.capabilities = options.capabilities or default_capabilities
    options.on_attach = options.on_attach or default_on_attach
    options.handlers = merge_handlers_with_default_handlers(options.handlers)

    require('lspconfig')[server_name].setup(options)
  end
})
