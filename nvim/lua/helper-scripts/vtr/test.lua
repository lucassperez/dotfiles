-- opts is a table like this: { cur_file = true, cur_line = false }
-- Possible options: { cur_file, cur_line, cur_dir }
function runAutomatedTest(opts)
  local filetype = vim.bo.filetype
  local filename = ''
  local line_number = ''

  -- Checks for current file option
  if opts.cur_file then
    filename = vim.fn.expand('%')
  end

  -- Checks for current cursor line option
  if opts.cur_line then
    line_number = ':'..vim.fn.line('.')
  end

  -- Checks for current directory option
  -- This should override cur_file and cur_line options
  if opts.cur_dir then
    filename = vim.fn.expand('%:h')
    line_number = ''
  end

  if (filetype == 'elixir') then
    vim.fn.VtrSendCommand('mix test '..filename..line_number)
  elseif (filetype == 'ruby') then
    vim.fn.VtrSendCommand('bundle exec rspec '..filename..line_number)
  else
    print('Não sei executar testes automatizados para arquivos do tipo '..filetype)
  end
end
