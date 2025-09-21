local test_cache = ''

local function directory_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

local function kaochaFilename(opts)
  opts = opts or {}

  if not opts.cur_file then return '' end

  local filename = vim.fn.expand('%h')
  if not filename:match('^.*test/.*_test.clj$') then filename = TestAndFile.filenamesFunctions.clojure() end

  return ' --focus ' .. filename:gsub('^(.*)test/(.*)_test.clj$', '%2-test'):gsub('/', '.')
end

-- TODO o que acontece se estivermos numa linha entre duas funções,
-- mas não dentro de nenhuma? Com a implementação atual, vai buscar
-- pra cima até achar o match, então vai rodar o teste anterior ao meu.
-- É isso que a gente quer? É assim que funciona, o rspec e o ExUnit?
-- O ExUnit não roda nenhum teste. O rspec eu não sei.
local function goTestCommand(opts)
  local go_test = 'go test'
  local path = ' '
  local flags = ' '

  -- cur_line -> go test -run=...
  -- cur_dir  -> go test
  -- cur_file -> go test .
  -- all else -> go test ./...

  -- TODO em go, é possível passar para o -run algo assim:
  -- go test -run=TestName/subTestName/subtest_description_string
  -- Conseguir fazer isso? Não é nada trivial.
  if opts.cur_line then
    local line_nr = unpack(vim.api.nvim_win_get_cursor(0))

    local i = line_nr
    while i > 0 do
      local line = vim.fn.getline(i)
      local testMatch = string.match(line, '^func (Test.*)%(t %*testing%.[A-Z]+%)')
      if testMatch then
        flags = ' -v -run=' .. testMatch .. ' '
        path = vim.fn.expand('%')
        break
      end

      local exampleMatch = string.match(line, '^func (Example.*)%(%)')
      if exampleMatch then
        flags = ' -v -run=' .. exampleMatch .. ' '
        path = vim.fn.expand('%')
        break
      end

      i = i - 1
    end
  end

  if opts.cur_dir then path = vim.fn.expand('%:h') end

  if opts.cur_file and not opts.cur_line then
    path = vim.fn.expand('%')
    flags = ' -v '
  end

  if path == ' ' and (not opts.cur_dir and not opts.cur_file and not opts.cur_line) then path = '...' end

  return string.format('%s%s./%s', go_test, flags, path)
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
    if directory_exists('spec/') then
      test_command = 'bundle exec rspec ' .. filename .. line_number
    else
      test_command = 'bundle exec rails test ' .. filename .. line_number
    end
  elseif filetype == 'typescriptreact' or filetype == 'typescript' then
    test_command = 'yarn test ' .. filename
  elseif filetype == 'clojure' then
    if directory_exists('bin/kaocha') then
      test_command = 'lein kaocha' .. kaochaFilename(opts)
    else
      test_command = 'lein test ' .. filename
    end
  elseif filetype == 'go' then
    --[[
    go test           current directory mode
    go test .         current package mode
    go test ./...     current package and all its sub packages mode
    go test net/http  specific package mode

    go test run=<funcName to match>
    ]]
    test_command = goTestCommand(opts)
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

function GetTestCache()
  return P(test_cache)
end

vim.api.nvim_create_user_command('GetTestCache', GetTestCache, {})
