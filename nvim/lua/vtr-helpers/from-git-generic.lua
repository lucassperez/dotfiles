function genericLinter()
  -- local filetype = vim.bo.filetype

  -- if filetype == 'startify' then
  --   filetype = io.popen('sh ~/scripts/git-stuff/get-project-lang.sh'):read()
  -- end

  local command =
    -- io.popen('sh ~/scripts/git-stuff/get-files/'..filetype..'-linter.sh noclipboard')
    io.popen('sh ~/scripts/git-stuff/get-files/generic-linter.sh noclipboard --strict')
    :read('*a')
    :gsub('\n', '')

  vim.fn.VtrSendCommand(command)
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

  vim.fn.VtrSendCommand(command)
end

_G.fromGit = {
  genericLinter = genericLinter,
  genericTest = genericTest,
}
