local defaults = require('lsp.defaults')

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

  for _, pkg in ipairs(require('mason-registry').get_installed_packages()) do
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
        -- Mason and neovim uses different names for the servers, unfortunately.
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

return {
  get_installed_servers = get_installed_servers,
  setup_server = setup_server,
}
