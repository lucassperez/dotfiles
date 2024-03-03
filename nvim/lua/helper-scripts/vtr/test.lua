local test_cache = ''

local function kaochaFilename(opts)
  opts = opts or {}

  if not opts.cur_file then return '' end

  local filename = vim.fn.expand('%h')
  if not filename:match('^.*test/.*_test.clj$') then filename = TestAndFile.filenamesFunctions.clojure() end

  return ' --focus ' .. filename:gsub('^(.*)test/(.*)_test.clj$', '%2-test'):gsub('/', '.')
end

-- opts is a table like this: { cur_file = true, cur_line = false }
-- Possible options: { cur_file, cur_line, cur_dir }
function RunAutomatedTest(opts)
  opts = opts or {}

  local filetype = vim.bo.filetype
  local filename = ''
  local line_number = ''

  -- Checks for current file option
  if opts.cur_file then filename = vim.fn.expand('%') end

  -- Checks for current cursor line option
  if opts.cur_line then line_number = ':' .. vim.fn.line('.') end

  -- Checks for current directory option
  -- This should override cur_file and cur_line options
  if opts.cur_dir then
    filename = vim.fn.expand('%:h')
    line_number = ''
  end

  local test_command = ''
  if filetype == 'elixir' then
    test_command = 'mix test ' .. filename .. line_number
  elseif filetype == 'ruby' then
    test_command = 'bundle exec rspec ' .. filename .. line_number
  elseif filetype == 'typescriptreact' or filetype == 'typescript' then
    test_command = 'yarn test ' .. filename
  elseif filetype == 'clojure' then
    local file = io.open('bin/kaocha')
    if file then
      file:close()
      test_command = 'lein kaocha' .. kaochaFilename(opts)
    else
      test_command = 'lein test ' .. filename
    end
  else
    vim.notify('Não sei executar testes automatizados para arquivos do tipo ' .. filetype)
    return
  end

  test_cache = test_command
  vim.cmd.VtrSendCommand(test_command)
end

function RunLastTest()
  if test_cache == '' then
    P('Ainda não foi executado nenhum teste para por no cache')
    return
  end

  vim.cmd.VtrSendCommand(test_cache)
end
