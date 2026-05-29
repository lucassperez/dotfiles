function P(...)
  if ... == nil then
    vim.notify('nil', vim.log.levels.INFO)
    return
  end

  for _, value in pairs({ ... }) do
    if type(value) == 'string' then
      vim.notify(value, vim.log.levels.INFO)
    else
      vim.notify(vim.inspect(value), vim.log.levels.INFO)
    end
  end

  return ...
end

local protected_require = require('protected_require')

protected_require.try_require('ui2')
protected_require.try_require('keymappings')
protected_require.try_require('settings')
protected_require.try_require('commands')
protected_require.try_require('plugins')
protected_require.try_require('statusline')
protected_require.try_require('tabline')
protected_require.try_require('tmux')

local helper_scripts = protected_require.try_require('helper-scripts')
if helper_scripts then
  helper_scripts.require_scripts(protected_require.try_require)
end

protected_require.try_require('intro')

local local_config = vim.fs.joinpath(vim.fn.stdpath('config'), 'nvim-local_init.lua')
if vim.fn.filereadable(local_config) == 1 then
  vim.cmd.source(local_config)
end

protected_require.report_errors()
