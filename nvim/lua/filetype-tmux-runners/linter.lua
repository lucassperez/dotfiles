-- opts is a table like this: { cur_file = true }
function _G.runLinter(opts)
  local filetype = vim.bo.filetype
  local filename = ''
  local line = ''

  -- check for current file option
  if opts.cur_file then
    filename = vim.fn.expand('%')
  end

  if (filetype == 'elixir') then
    vim.fn.VtrSendCommand('mix credo '..filename)
  elseif (filetype == 'ruby') then
    vim.fn.VtrSendCommand('bundle exec rubocop '..filename)
  else
    print('Não sei rodar um linter para arquivos do tipo '..filetype)
  end
end
