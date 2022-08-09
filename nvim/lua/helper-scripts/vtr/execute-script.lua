local runCommands = {
  elixir = 'elixir ',
  ruby = 'ruby ',
  sh = 'sh ',
  javascript = 'node ',
  lua = 'lua ',
  -- rust = 'rustc ', oh no
  go = 'go run ',
  clojure = 'clj -M ',
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

  if filetype == 'rust' then
    -- Could use vim.fn.expand('%:r'), but I have no idea which is better/faster
    filename_without_extension = filename:match('(.*)%.rs$')
    return 'rustc '..filename..' && ./'..filename_without_extension,
           'Compiling and hopefully running '..filename
  end

  command = runCommands[filetype]
  if command == nil then
    return nil, 'Não sei executar arquivos do tipo '..filetype
  end

  return command..full_path_filename,
         command..filename
end

function executeFileAsScript()
  local command, printMessage = getRunCommand()

  if command == nil then
    print(printMessage)
    return
  end

  vim.fn.VtrSendCommand(command)
  print(printMessage)
end

function autoExecuteOnSave()
  local command, printMessage = getRunCommand()
  local filename = vim.fn.expand('%')

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
