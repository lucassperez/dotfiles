-- vim.lsp.set_log_level('debug')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Ver isso depois? https://github.com/ray-x/lsp_signature.nvim

local defaults = require('plugins.lsp.defaults')
local default_on_attach = defaults.on_attach
local default_capabilities = defaults.capabilities

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

    require('lspconfig')[server_name].setup(options)
  end
})
