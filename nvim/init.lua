-- Useful to print tables
function P(...)
  if ... == nil then
    vim.notify('nil')
    return
  end

  for _, value in pairs({ ... }) do
    if type(value) == 'string' then
      vim.notify(value)
    else
      vim.notify(vim.inspect(value))
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
    if not any_require_failed then print('ERROR!') end

    any_require_failed = true
    print('Could not require the path `' .. path .. '`')

    -- Print only first line of the error
    print('  ' .. string.sub(result, 1, string.find(result, '\n')))

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

protected_require('keymappings')
protected_require('settings')
protected_require('commands') -- Vimscript used to create commands
protected_require('plugins')
-- At some point I made the plugins/init.lua return a function that received
-- the protected_require function and use it inside the lazy config calls,
-- but I think lazy makes it reliable enough that the module will always be
-- loaded when calling the plugins, so the protected_require was no longer
-- needed for loading plugins configurations.

-- https://www.reddit.com/r/neovim/comments/14ecf5o/semantic_highlights_messing_with_todo_comments/
-- https://github.com/stsewd/tree-sitter-comment/issues/22
vim.api.nvim_set_hl(0, '@lsp.type.comment', {})

-- Meus próprios scritpts
protected_require('helper-scripts').require_scripts(protected_require)

if any_require_failed then
  print('---')
  print('Check file ' .. protected_require_log_file_path .. '/nvim-require.log for more information')
end
