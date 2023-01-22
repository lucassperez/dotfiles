local function kaochaFilename(opts)
  if not opts.cur_file then return '' end

  local filename = vim.fn.expand('%h')
  if not filename:match('^.*test/.*_test.clj$') then
    filename = testAndFile.filenamesFunctions.clojure()
  end

  return ' --focus '..
            filename
              :gsub('^(.*)test/(.*)_test.clj$', '%2-test')
              :gsub('/', '.')
end

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
  elseif (filetype == 'typescriptreact' or filetype == 'typescript') then
    vim.fn.VtrSendCommand('yarn test '..filename)
  elseif (filetype == 'clojure') then
    local file = io.open('bin/kaocha')
    if file then
      file:close()
      vim.fn.VtrSendCommand('lein kaocha'..kaochaFilename(opts))
    else
      vim.fn.VtrSendCommand('lein test '..filename)
    end
  else
    print('Não sei executar testes automatizados para arquivos do tipo '..filetype)
  end
end

-- TODO make this good
function runLastTest()
  local filetype = vim.bo.filetype

  local grep_string = ''
  if (filetype == 'elixir') then
    grep_string = 'test'
  elseif (filetype == 'ruby') then
    grep_string = 'rspec'
  else
    print('Não sei pelo o que procurar para arquivos do tipo '..filetype)
    return
  end

  local command_string =
    '$('
      ..'history 0 | grep '
      ..'"'..grep_string..'"'
      ..' | tail -1 | cut -d " " -f 4-'
    ..')'

  -- local p = io.popen(command_string)
  -- if p == nil then return end
  -- local output = p:read()
  -- p:close()
  -- print(output)
  -- vim.fn.VtrSendCommand('echo '..output..' && $('..output..')')
  vim.fn.VtrSendCommand('vtr_last_test='..command_string)
  vim.fn.VtrSendCommand('echo "$vtr_last_test" && echo "$vtr_last_test" | bash -')
end
