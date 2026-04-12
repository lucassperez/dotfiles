-- Useful to print tables
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

local any_require_failed = false
local protected_require_log_file_path = vim.fn.stdpath('config') .. '/nvim-require.log'

local function protected_require(path)
  local ok, result = pcall(require, path)
  if not ok then
    -- Only print this the first time a pcall returned an error
    if not any_require_failed then vim.notify('ERROR!', vim.log.levels.ERROR) end

    any_require_failed = true
    vim.notify('Could not require the path `' .. path .. '`', vim.log.levels.ERROR)

    -- Print only first line of the error
    -- vim.notify('  ' .. string.sub(result, 1, string.find(result, '\n')), vim.log.levels.ERROR)

    -- Get first 7 lines
    local tbl_lines = vim.split(result, '\n')
    local str_lines = table.concat(vim.list_slice(tbl_lines, 1, 7), '\n')
    vim.notify(str_lines, vim.log.levels.ERROR)

    local file = io.open(protected_require_log_file_path, 'a')
    if file then
      file:write('[' .. os.date('%Y-%m-%d_%H:%M:%S') .. ']: ' .. path .. '\n')
      file:write(result)
      file:write('\n---\n')
      file:close()
    end
  end

  return result
end

-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

-- Sobre as cores:
-- https://icyphox.sh/blog/nvim-lua/

protected_require('ui2')
protected_require('intro')
protected_require('keymappings')
protected_require('settings')
protected_require('commands')
protected_require('new-plugins')
protected_require('statusline')

-- At some point I made the plugins/init.lua return a function that received
-- the protected_require function and use it inside the lazy config calls,
-- but I think lazy makes it reliable enough that the module will always be
-- loaded when calling the plugins, so the protected_require was no longer
-- needed for loading plugins configurations.

-- Meus próprios scritpts
protected_require('helper-scripts').require_scripts(protected_require)

if any_require_failed then
  vim.notify('---', vim.log.levels.ERROR)
  vim.notify('Check file ' .. protected_require_log_file_path .. '/nvim-require.log for more information', vim.log.levels.ERROR)
end
