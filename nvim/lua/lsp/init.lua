-- LspInfo to see log file location, but probably ~/.local/state/nvim/lsp.log
-- vim.lsp.set_log_level('debug')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Ver isso depois? https://github.com/ray-x/lsp_signature.nvim

local defaults = require('lsp.defaults')

require('plugins.fidget')
require('mason').setup()
local mason_registry = require('mason-registry')

local ensure_installed = {
  'lua_ls',
  'marksman',
}

local function config_file_exists(filename)
  local path = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'lsp', 'configs',  filename .. '.lua')
  return vim.fn.filereadable(path) == 1
end

local function get_server_opts(server_name)
  if not config_file_exists(server_name) then
    return {}, nil
  end

  local ok, result, hook = pcall(require, 'lsp.configs.' .. server_name)

  if not ok then
    vim.notify(
      string.format(
        'Failed at loading config file for %s\n%s',
        server_name,
        result
      ), vim.log.levels.ERROR
    )
    return {}, nil
  end

  if type(result) ~= 'table' then
    vim.notify(
      string.format(
        'Config options for language server must be a table: %s\nIgnoring returned value: %s',
        server_name,
        vim.inspect(result)
      ), vim.log.levels.ERROR
    )
    result = {}
  end

  if hook and type(hook) ~= 'function' then
    vim.notify(
      string.format(
        'Hook for language server must be a function: %s\nIgnoring returned value: %s',
        server_name,
        vim.inspect(result)
      ), vim.log.levels.ERROR
    )
    hook = nil
  end

  return result, hook
end

local function merge_capabilities_with_defaults(custom)
  return vim.tbl_deep_extend('force', {}, defaults.capabilities, custom or {})
end

local function merge_on_attach_with_defaults(custom)
  return function (client, bufnr)
    defaults.on_attach(client, bufnr)
    if custom then
      custom(client, bufnr)
    end
  end
end

local function get_installed_servers()
  local servers = {}
  local seen = {}

  for _, pkg in ipairs(mason_registry.get_installed_packages()) do
    local spec = pkg.spec

    if spec.categories and vim.tbl_contains(spec.categories, 'LSP') then
      local lsp_name = spec.neovim and spec.neovim.lspconfig
      if lsp_name == nil then
        vim.notify('Não foi possível mapear o nome do LSP: ' .. vim.inspect(spec.name), vim.log.levels.ERROR)
      end

      if seen[lsp_name] then
        vim.notify('LSP duplicada do mason registry? :O ' .. lsp_name, vim.notify.WARN)
      end

      if lsp_name and vim.lsp.config[lsp_name] and not seen[lsp_name] then
        -- Mason and neovim uses different names for the servers, unfortunately
        -- For example, mason uses lua-language-server, and neovim, lua_ls.
        -- Fortunately, the mason package spec seems to have a mapping available.
        table.insert(servers, spec.neovim.lspconfig)
        seen[lsp_name] = true
      end
    end
  end

  return servers, seen
end

local function setup_server(server_name)
  local options, hook = get_server_opts(server_name)

  options.capabilities = merge_capabilities_with_defaults(options.capabilities)
  options.on_attach = merge_on_attach_with_defaults(options.on_attach)

  if type(hook) == 'function' then
    hook(options)
  end

  vim.lsp.config(server_name, options)
  vim.lsp.enable(server_name)
end

local function install_ensured(seen)
  local missing = {}

  for _, lsp_name in pairs(ensure_installed) do
    if not seen[lsp_name] then
      table.insert(missing, lsp_name)
    end
  end

  if #missing == 0 then
    return
  end

  local all_packages = mason_registry.get_all_packages()
  for _, ensured in ipairs(missing) do
    for _, pkg in ipairs(all_packages) do
      local spec = pkg.spec
      local name

      if pkg.name == ensured then
        name = ensured
      else
        name = spec.neovim and spec.neovim.lspconfig
      end

      if name and name == ensured then
        if not pkg:is_installed() then
          print('Installing Mason package: ' .. ensured)
          pkg:install()
          setup_server(ensured)
        end

        break
      end
    end
  end
end

local installed_servers, seen = get_installed_servers()

install_ensured(seen)

for _, server_name in ipairs(installed_servers) do
  setup_server(server_name)
end

vim.lsp.document_color.enable(false)
-- https://www.reddit.com/r/neovim/comments/14ecf5o/semantic_highlights_messing_with_todo_comments/
-- https://github.com/stsewd/tree-sitter-comment/issues/22
vim.api.nvim_set_hl(0, '@lsp.type.comment', {})

vim.diagnostic.config({
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = 'cursor',
        focus = false
      })
    end,
  },
})

vim.api.nvim_create_user_command('LspStart', function(opts)
  if #opts.fargs > 0 then
    for _, server_name in pairs(opts.fargs) do
      setup_server(server_name)
      vim.notify('LSP started for ' .. table.concat(opts.fargs), vim.log.levels.INFO)
    end
    return
  end

  local servers = get_installed_servers()

  for _, server in ipairs(servers) do
    setup_server(server)
  end

  vim.notify('LSP started for installed servers', vim.log.levels.INFO)
end, {
  nargs = '*',
  complete = function()
    return installed_servers
  end,
})

vim.api.nvim_create_user_command('LspStop', function(opts)
  local clients = vim.lsp.get_clients(opts.fargs)

  if #clients == 0 then
    vim.notify('No clients to stop', vim.log.levels.INFO)
    return
  end

  for _, client in ipairs(clients) do
    client:stop()
    vim.notify('Client stopped: ' .. client.name, vim.log.levels.INFO)
  end
end, {
  nargs = '*',
  complete = function()
    return installed_servers
  end,
})

vim.api.nvim_create_user_command('LspRestart', function(opts)
  local clients = vim.lsp.get_clients(opts.fargs)

  for _, client in ipairs(clients) do
    client:stop()
  end

  for _, client in ipairs(clients) do
    vim.defer_fn(function()
      setup_server(client.name)
    end, 500)
  end

  vim.notify('LSP restarted', vim.log.levels.INFO)
end, {
nargs = '*',
complete = function()
  return installed_servers
end,
})
