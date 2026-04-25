-- scope one of file|line|dir|all
local function run(scope)
  scope = scope or 'file'

  local filetype = vim.bo.filetype
  local filename = ''

  -- check for current file option
  if scope == 'file' or scope == 'line' then
    filename = vim.fn.expand('%')
  end

  if scope == 'dir' then
    filename = vim.fn.expand('%:h')
  end

  local cmd = ''

  if filetype == 'elixir' then
    cmd = 'mix format --check-formatted ' .. filename .. ' && mix credo --strict ' .. filename
  elseif filetype == 'ruby' then
    cmd = 'bundle exec rubocop ' .. filename
  else
    vim.notify('Não sei rodar um linter para arquivos do tipo ' .. filetype, vim.log.levels.ERROR)
  end

  require('tmux.runner').send_tmux_keys(cmd)
end

return {
  run = run,
}
