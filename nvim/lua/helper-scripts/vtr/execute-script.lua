local function ruby_function(filename, full_path_filename)
  local extension = filename:match('.*%.(.*)$')
  if extension == 'ru' then
    return 'rackup ' .. full_path_filename, filename
  else
    return 'ruby ' .. full_path_filename, filename
  end
end

local function rust_function(filename, full_path_filename)
  local filename_without_extension = filename:match('(.*)%.rs$')
  local bin_name = filename_without_extension .. '-nvim-rust-bin'
  return 'rustc -o ' .. bin_name .. ' ' .. full_path_filename .. ' && ./' .. filename_without_extension,
    'Hopefully compiling and running ' .. filename
end

local function c_function(filename, full_path_filename)
  local filename_without_extension = filename:match('(.*)%.c$')
  local bin_name = filename_without_extension .. '-nvim-c-bin'
  return 'gcc -o ' .. bin_name .. ' ' .. full_path_filename .. ' && ./' .. bin_name,
    'Hopefully compiling and running ' .. filename
end

local runCommands = {
  elixir = 'elixir ',
  ruby = ruby_function,
  sh = 'sh ',
  javascript = 'node ',
  lua = 'lua ',
  rust = rust_function,
  go = 'go run ',
  clojure = 'clj -M ',
  c = c_function,
}

local function getRunCommand()
  local first_line = vim.fn.getline(1)
  local prog_shebang = string.match(first_line, '^%s*#%s*!%s*([%w/ -]+)')
  local full_path_filename = vim.fn.expand('%:p')
  local filename = vim.fn.expand('%')

  if prog_shebang then return prog_shebang .. ' ' .. full_path_filename, prog_shebang .. ' ' .. filename end

  local filetype = vim.bo.filetype

  local command = runCommands[filetype]
  if command == nil then
    return nil, 'Não sei executar arquivos do tipo ' .. filetype
  elseif type(command) == 'function' then
    return command(filename, full_path_filename)
  end

  return command .. full_path_filename, command .. filename
end

function ExecuteFileAsScript()
  local command, printMessage = getRunCommand()

  if command then
    local ok, err = pcall(vim.cmd.VtrSendCommand, command)
    if not ok then
      print('[helper-scripts/vtr/execute-script](ExecuteFileAsScript) ' .. err)
      return
    end
  end

  print(printMessage)
end

local _auto_execute_on_save = {
  active = false,
  autocmd_id = nil,
  filename = nil,
}

function AutoExecuteOnSave()
  local filename = vim.fn.expand('%')

  if _auto_execute_on_save.active and _auto_execute_on_save.filename ~= filename then
    print('Auto run is already on for ' .. _auto_execute_on_save.filename)
    return
  end

  if _auto_execute_on_save.active then
    print('Auto run stopped')
    vim.api.nvim_del_autocmd(_auto_execute_on_save.autocmd_id)
    _auto_execute_on_save.active = false
    _auto_execute_on_save.autocmd_id = nil
    _auto_execute_on_save.filename = nil
    return
  end

  local command, printMessage = getRunCommand()

  if command == nil then
    print(printMessage)
    return
  end

  _auto_execute_on_save.active = true
  _auto_execute_on_save.filename = filename

  _auto_execute_on_save.autocmd_id = vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('AutoExecuteOnSave', { clear = true }),
    callback = function()
      local ok, err = pcall(vim.cmd.VtrSendCommand, command)
      if not ok then
        print('[helper-scripts/vtr/execute-script](AutoExecuteOnSave) ' .. err)
        return
      end
    end,
    desc = 'Auto execute on save for file ' .. filename,
  })

  print('Auto run started for ' .. filename)
end
