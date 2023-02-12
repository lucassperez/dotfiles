-- Useful to print tables
function P(...)
  for _, value in pairs({...}) do
    print(vim.inspect(value))
  end
  return ...
end

local any_require_failed = false
local protected_require_log_file_path = vim.fn.stdpath('config')..'/nvim-require.log'

local function protected_require(path)
  local ok, result = pcall(require, path)
  if not ok then
    -- Only print this the first time a pcall returned an error
    if not any_require_failed then print('ERROR!') end

    any_require_failed = true
    print('Could not require the path `'..path..'`')

    -- Print only first line of the error
    print('  '..string.sub(result, 1, string.find(result, '\n')))

    local file = io.open(protected_require_log_file_path, 'a')
    if file then
      file:write('['..os.date('%Y-%m-%d-%H:%M:%S')..']: '..path..'\n')
      file:write(result)
      file:write('\n---\n')
      file:close()
    end
  end
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

-- Meus próprios scritpts
protected_require('helper-scripts.vtr.test')
protected_require('helper-scripts.vtr.linter')
protected_require('helper-scripts.vtr.from-git-generic')
protected_require('helper-scripts.vtr.execute-script')
protected_require('helper-scripts.vtr.send-line-to-tmux')
protected_require('helper-scripts.vtr.compile-file')
protected_require('helper-scripts.togglebetweentestandfile')
protected_require('helper-scripts.write-debugger-breakpoint')

if any_require_failed then
  print('---')
  print('Check file '..protected_require_log_file_path..'/nvim-require.log for more information')
end
