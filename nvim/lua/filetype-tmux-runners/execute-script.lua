local filetype = vim.bo.filetype
local full_path_filename = vim.fn.expand('%:p')
local filename = vim.fn.expand('%')

if (filetype == 'elixir') then
  vim.fn.VtrSendCommand('elixir '..full_path_filename)
  print('executando elixir '..filename)

elseif (filetype == 'ruby') then
  vim.fn.VtrSendCommand('ruby '..full_path_filename)
  print('executando ruby '..filename)

elseif (filetype == 'sh') then
  -- TODO Verify if first line has a bash shebang to run with bash and not sh
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
