local runner = require('tmux.runner')

local function ruby_function(filename, full_path_filename)
  local extension = filename:match('.*%.(.*)$')
  if extension == 'ru' then
    return 'rackup ' .. full_path_filename, filename
  else
    return 'ruby ' .. full_path_filename, filename
  end
end

local function rust_function(filename, full_path_filename)
  local filename_without_extension = filename:match('(.*)%.rs$')
  local bin_name = filename_without_extension .. '-nvim-rust-bin'
  return 'rustc -o ' .. bin_name .. ' ' .. full_path_filename .. ' && ./' .. filename_without_extension,
    'Hopefully compiling and running ' .. filename
end

local function c_function(filename, full_path_filename)
  local filename_without_extension = filename:match('(.*)%.c$')
  local bin_name = filename_without_extension .. '-nvim-c-bin'
  return 'gcc -o ' .. bin_name .. ' ' .. full_path_filename .. ' && ./' .. bin_name,
    'Hopefully compiling and running ' .. filename
end

local run_commands = {
  elixir = 'elixir ',
  ruby = ruby_function,
  sh = 'sh ',
  javascript = 'node ',
  lua = 'lua ',
  rust = rust_function,
  go = 'go run ',
  clojure = 'clj -M ',
  c = c_function,
}

-- Build command based on shebang or filetype
local function build_command()
  local first_line = vim.fn.getline(1)
  local prog_shebang = string.match(first_line, '^%s*#%s*!%s*([%w/ -]+)')
  local full_path = vim.fn.expand('%:p')
  local filename = vim.fn.expand('%')

  if prog_shebang then
    return prog_shebang .. ' ' .. full_path,
      prog_shebang .. ' ' .. filename
  end


  local filetype = vim.bo.filetype
  local cmd = run_commands[filetype]

  if not cmd then
    return nil, 'Não sei executar arquivos do tipo ' .. filetype
  end

  if type(cmd) == 'function' then
    return cmd(filename, full_path)
  end

  return cmd .. full_path,
         cmd .. filename
end

local function execute_file()
  local command, msg = build_command()

  if not command then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  runner.send_tmux_keys(command)
end

local auto_execute = {
  active = false,
  autocmd_id = nil,
  filename = nil,
}

local function toggle_auto_execute()
  local filename = vim.fn.expand('%')

  if auto_execute.active and auto_execute.filename ~= filename then
    vim.notify('Auto run is already on for ' .. auto_execute.filename, vim.log.levels.WARN)
    return
  end

  if auto_execute.active then
    vim.api.nvim_del_autocmd(auto_execute.autocmd_id)
    auto_execute.active = false
    auto_execute.autocmd_id = nil
    auto_execute.filename = nil

    vim.cmd.echohl('String')
    vim.notify('Auto run stopped', vim.log.levels.WARN)
    vim.cmd.echohl('None')
    return
  end

  local command, msg = build_command()

  if not command then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  local group = vim.api.nvim_create_augroup('MyTmuxAutoExecute', { clear = true })

  auto_execute.autocmd_id = vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    callback = function()
      runner.send_tmux_keys(command)
    end,
    desc = 'Auto execute on save for file ' .. filename,
  })

  auto_execute.active = true
  auto_execute.filename = filename


  vim.cmd.echohl('String')
  vim.cmd.echo(string.format([['Auto run started for %s']], filename))
  vim.cmd.echohl('None')
end

return {
  execute_file = execute_file,
  toggle_auto_execute = toggle_auto_execute,
}
