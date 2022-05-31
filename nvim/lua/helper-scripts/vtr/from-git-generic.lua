function genericLinter()
  -- local filetype = vim.bo.filetype

  -- if filetype == 'startify' then
  --   filetype = io.popen('sh ~/scripts/git-stuff/get-project-lang.sh'):read()
  -- end

  local command =
    -- io.popen('sh ~/scripts/git-stuff/get-files/'..filetype..'-linter.sh noclipboard')
    io.popen('~/scripts/git-stuff/get-files/generic-linter.sh noclipboard')
    :read('*a')
    :gsub('\n', '')

  if command ~= '' then
    vim.fn.VtrSendCommand(command)
  else
    print('genericLinter: Nenhum arquivo encontrado')
  end
end

function genericTest()
  -- local filetype = vim.bo.filetype

  -- if filetype == 'startify' then
  --   filetype = io.popen('sh ~/scripts/git-stuff/get-project-lang.sh'):read()
  -- end

  local command =
    io.popen('sh ~/scripts/git-stuff/get-files/generic-test.sh noclipboard')
    :read('*a')
    :gsub('\n', '')

  if command ~= '' then
    vim.fn.VtrSendCommand(command)
  else
    print('genericTest: Nenhum arquivo encontrado')
  end
end

fromGit = {
  genericLinter = genericLinter,
  genericTest = genericTest,
}
