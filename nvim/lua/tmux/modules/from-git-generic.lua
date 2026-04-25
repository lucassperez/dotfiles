local runner = require('tmux.runner')

local function exec_script(path)
  local p = io.popen(path)

  if p == nil then
    return nil, 'Algo de errado aconteceu ao buscar os arquivos'
  end

  local command = p:read('*a')
  p:close()

  if command == nil then
    return nil, 'Sem saída'
  end

  if command == '' then
    return nil, 'Sem comando'
  end

  return command, ''
end

local function generic_linter(clear_screen)
  local cmd, err = exec_script('sh ~/scripts/git-stuff/get-files/generic-linter.sh noclipboard')

  if not cmd then
    vim.notify('generic_linter: ' .. err, vim.log.levels.WARN)
    return
  end

  runner.send_tmux_keys(cmd, clear_screen)
end

local function generic_test(clear_screen)
  local cmd, err = exec_script('sh ~/scripts/git-stuff/get-files/generic-test.sh noclipboard', clear_screen)

  if not cmd then
    vim.notify('generic_test: ' .. err, vim.log.levels.WARN)
    return
  end

  runner.send_tmux_keys(cmd, clear_screen)
end

return {
  test = generic_test,
  linter = generic_linter,
}
