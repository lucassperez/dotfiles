local runner = require('tmux.runner')
local modules = require('tmux.modules')

local scopes = {
  from_git_generic = { 'test', 'linter' },
  test = { 'file', 'line', 'dir', 'all', 'last', 'get_cache' },
  linter = { 'file', 'line', 'dir', 'all' },
  execute_file = { 'now', 'toggle' },
}

local function guard(scope, list)
  if scope and not vim.tbl_contains(list, scope) then
    vim.notify(
      string.format(
        'Subcomando inválido: %s. Opções válidas: [%s]',
        scope,
        table.concat(list, ', ')
      ),
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

local function complete(list)
  return function()
    return list
  end
end

------------
-- RUNNER --
------------

vim.api.nvim_create_user_command('TmuxAttach', function()
  runner.attach_pane()
end, {})

vim.api.nvim_create_user_command('TmuxSend', function(opts)
  if opts.range > 0 and #opts.fargs > 0 then
    vim.notify(
      'TmuxSend: não é permitido passar argumentos e um range simultaneamente',
      vim.log.levels.ERROR
    )
    return
  end

  local clear_screen = not opts.bang

  if #opts.fargs > 0 then
    runner.send_tmux_keys(opts.args, clear_screen)
    return
  end

  if opts.range > 0 then
    local lines = vim.api.nvim_buf_get_lines(
      0,
      opts.line1 - 1,
      opts.line2,
      false
    )
    runner.send_tmux_keys(table.concat(lines, '\n'), clear_screen)
    return
  end

  runner.send_tmux_keys(vim.api.nvim_get_current_line(), clear_screen)
end, {
  nargs = '*',
  range = true,
  bang = true,
})

----------------------
-- FROM GIT GENERIC --
----------------------

vim.api.nvim_create_user_command('FromGitGeneric', function(opts)
  local scope = opts.fargs[1] or 'test'

  if not guard(scope, scopes.from_git_generic) then return end

  local clear_screen = not opts.bang

  if scope == 'test' then
    modules.from_git_generic.test(clear_screen)
  elseif scope == 'linter' then
    modules.from_git_generic.linter(clear_screen)
  end
end, {
  complete = complete(scopes.from_git_generic),
  nargs = '?',
  bang = true,
})

----------
-- TEST --
----------

vim.api.nvim_create_user_command('TmuxTest', function(opts)
  local scope = opts.fargs[1] or 'all'

  if not guard(scope, scopes.test) then return end

  if scope == 'last' then
    modules.test.run_last()
    return
  end

  if scope == 'get_cache' then
    modules.test.get_test_cache()
    return
  end

  modules.test.run(scope)
end, {
  nargs = '?',
  complete = complete(scopes.test),
})

------------
-- LINTER --
------------

vim.api.nvim_create_user_command('TmuxLinter', function(opts)
  local scope = opts.fargs[1] or 'all'

  if not guard(scope, scopes.linter) then return end

  modules.linter.run(scope)
end, {
  nargs = '?',
  complete = complete(scopes.linter),
})

------------------
-- EXECUTE FILE --
------------------

vim.api.nvim_create_user_command('TmuxExecuteFile', function(opts)
  local scope = opts.fargs[1] or 'now'

  if not guard(scope, scopes.execute_file) then return end

  if scope == 'now' then
    modules.execute_file.execute_file()
  elseif scope == 'toggle' then
    modules.execute_file.toggle_auto_execute()
  end
end, {
  nargs = '?',
  complete = complete(scopes.execute_file),
})

-------------
-- COMPILE --
-------------

-- Foda-se
