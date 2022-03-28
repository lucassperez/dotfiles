function compileFile()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%')

  if (filetype == 'elixir') then
    vim.fn.VtrSendCommand('elixirc '..filename)
  else
    print('Não sei compilar um arquivo do tipo '..filetype)
  end
end
