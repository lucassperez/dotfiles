-- LspInfo to see log file location, but probably ~/.local/state/nvim/lsp.log
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
local lspconfig = require('lspconfig')

mason_lspconfig.setup({
  ensure_installed = { 'lua_ls', 'marksman' },
})

local function config_file_exists(filename)
  local path = string.format('%s/lua/plugins/lsp/%s.lua', vim.fn.stdpath('config'), filename)
  return vim.fn.filereadable(path) == 1
end

mason_lspconfig.setup_handlers({
  function(server_name)
    local options = {}

    if config_file_exists(server_name) then
      local ok, result = pcall(require, 'plugins.lsp.' .. server_name)
      if not ok then
        vim.notify(result, vim.log.levels.WARN)
      elseif type(result) == 'table' then
        options = result
      end
    -- else
    --   vim.notify('Config file for '..server_name..' does not exist', vim.log.levels.INFO)
    end

    options.capabilities = options.capabilities or default_capabilities
    options.on_attach = options.on_attach or default_on_attach

    -- I wish
    -- https://www.reddit.com/r/neovim/comments/12fburw/feedback_when_lsp_dont_find_definition/
    -- This doesn't really work with my setup because I use telescope's definition,
    -- and not the default's vim.lsp handlers.
    -- local current_definition_handler = vim.lsp.handlers['textDocument/definition']
    -- vim.lsp.handlers['textDocument/definition'] = function(err, result, ctx, config)
    --   if not result then
    --     vim.notify('Could not find definition')
    --   end
    --   current_definition_handler(err, result, ctx, config)
    -- end

    lspconfig[server_name].setup(options)
  end,
})
