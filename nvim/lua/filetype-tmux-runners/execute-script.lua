local filetype = vim.bo.filetype
local full_path_filename = vim.fn.expand('%:p')
local filename = vim.fn.expand('%')

local first_line = vim.fn.getline(1)
local prog_shebang = string.match(first_line, '^#!(/[%w/ ]+)')

if prog_shebang then
  vim.fn.VtrSendCommand(prog_shebang..' '..full_path_filename)
  print('executando '..prog_shebang..' '..filename)

elseif (filetype == 'elixir') then
  vim.fn.VtrSendCommand('elixir '..full_path_filename)
  print('executando elixir '..filename)

elseif (filetype == 'ruby') then
  vim.fn.VtrSendCommand('ruby '..full_path_filename)
  print('executando ruby '..filename)

elseif (filetype == 'sh') then
  -- Note that bash scripts usually have the sh filetype as well. This script
  -- will only use bash if a shebang is specified at the first line.
  vim.fn.VtrSendCommand('sh '..full_path_filename)
  print('executando sh '..filename)

elseif (filetype == 'javascript') then
  vim.fn.VtrSendCommand('node '..full_path_filename)
  print('executando node '..filename)

elseif (filetype == 'lua') then
  vim.fn.VtrSendCommand('lua '..full_path_filename)
  print('executando lua '..filename)

else
  print('Não sei executar arquivos do tipo '..filetype)
end
