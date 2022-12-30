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
  -- map('n', '\\r', function() vim.lsp.buf.references() end, map_opts)
  map('n', '\\r', function() require('telescope.builtin').lsp_references() end, map_opts)
  map('n', '\\d', function() vim.diagnostic.open_float() end, map_opts)
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
default_capabilities = require('cmp_nvim_lsp').default_capabilities(default_capabilities)

local default_handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { stylize_markdown = false, })
}

local function merge_handlers_with_default_handlers(handler)
  if not handler then return default_handlers end
  return handler["textDocument/hover"] or default_handlers["textDocument/hover"]
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
    local status, options = pcall(require, 'plugins.lsp.'..server_name)
    if not status then options = {} end

    options.capabilities = options.capabilities or default_capabilities
    options.on_attach = options.on_attach or default_on_attach
    options.handlers = merge_handlers_with_default_handlers(options.handlers)

    require('lspconfig')[server_name].setup(options)
  end
})
