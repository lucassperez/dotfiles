local function ruby_function(filename)
  local extension = filename:match('.*%.(.*)$')
  if extension == 'ru' then
    return 'rackup '..filename, filename
  else
    return 'ruby '..filename, filename
  end
end

local function rust_function(filename, full_path_filename)
  local filename_without_extension = filename:match('(.*)%.rs$')
  local bin_name = filename_without_extension .. '-nvim-rust-bin'
  return 'rustc -o '..bin_name..' '..full_path_filename..' && ./'..filename_without_extension,
         'Hopefully compiling and running '..filename
end

local function c_function(filename, full_path_filename)
  local filename_without_extension = filename:match('(.*)%.c$')
  local bin_name = filename_without_extension..'-nvim-c-bin'
  return 'gcc -o '..bin_name..' '..full_path_filename..' && ./'..bin_name,
         'Hopefully compiling and running '..filename
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

  if prog_shebang then
    return prog_shebang..' '..full_path_filename,
           prog_shebang..' '..filename
  end

  local filetype = vim.bo.filetype

  local command = runCommands[filetype]
  if command == nil then
    return nil, 'Não sei executar arquivos do tipo '..filetype
  elseif type(command) == 'function' then
    return command(filename, full_path_filename)
  end

  return command..full_path_filename,
         command..filename
end

function executeFileAsScript()
  local command, printMessage = getRunCommand()

  if command then vim.fn.VtrSendCommand(command) end
  print(printMessage)
end

local _auto_execute_on_save_running = nil

function autoExecuteOnSave()
  local filename = vim.fn.expand('%')

  if _auto_execute_on_save_running and
     _auto_execute_on_save_running ~= filename
  then
    print('Auto run is already on for '.._auto_execute_on_save_running)
    return
  end

  if _auto_execute_on_save_running then
    print('Auto run stopped')
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = vim.api.nvim_create_augroup('AutoExecuteOnSave', { clear = true }),
      callback = function() end,
    })
    _auto_execute_on_save_running = nil
    return
  end

  _auto_execute_on_save_running = filename

  local command, printMessage = getRunCommand()

  if command == nil then
    print(printMessage)
    return
  end

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('AutoExecuteOnSave', { clear = true }),
    callback = function()
      vim.fn.VtrSendCommand(command)
    end,
  })

  print('Auto run started for '..filename)
end
