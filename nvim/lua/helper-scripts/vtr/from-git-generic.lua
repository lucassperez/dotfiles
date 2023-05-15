local function genericLinter()
  -- local filetype = vim.bo.filetype

  -- if filetype == 'startify' then
  --   local p_lang = io.popen('sh ~/scripts/git-stuff/get-project-lang.sh')
  --   if p_lang ~= nil then
  --     filetype = p_lang:read()
  --     p_lang:close()
  --   end
  -- end

  -- local p = io.popen('sh ~/scripts/git-stuff/get-files/'..filetype..'-linter.sh noclipboard')
  local p = io.popen('~/scripts/git-stuff/get-files/generic-linter.sh noclipboard')
  if p == nil then
    print('genericLinter: Algo de errado aconteceu ao buscar os arquivos')
    return
  end

  local command = p:read('*a'):gsub('\n', '')
  p:close()

  if command ~= '' then
    vim.fn.VtrSendCommand(command)
  else
    print('genericLinter: Nenhum arquivo encontrado')
  end
end

local function genericTest()
  -- local filetype = vim.bo.filetype

  -- if filetype == 'startify' then
  --   local p_lang = io.popen('sh ~/scripts/git-stuff/get-project-lang.sh')
  --   if p_lang ~= nil then
  --     filetype = p_lang:read()
  --     p_lang:close()
  --   end
  -- end

  local p = io.popen('sh ~/scripts/git-stuff/get-files/generic-test.sh noclipboard')
  if p == nil then
    print('genericTest: Algo de errado aconteceu ao buscar os arquivos')
    return
  end
  local command = p:read('*a'):gsub('\n', '')
  p:close()

  if command ~= '' then
    vim.fn.VtrSendCommand(command)
  else
    print('genericTest: Nenhum arquivo encontrado')
  end
end

FromGit = {
  genericLinter = genericLinter,
  genericTest = genericTest,
}
