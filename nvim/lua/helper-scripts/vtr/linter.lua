-- opts is a table like this: { cur_file = true }
function RunLinter(opts)
  opts = opts or {}

  local filetype = vim.bo.filetype
  local filename = ''

  -- check for current file option
  if opts.cur_file then filename = vim.fn.expand('%') end

  if filetype == 'elixir' then
    vim.cmd.VtrSendCommand('mix format --check-formatted ' .. filename .. ' && mix credo --strict ' .. filename)
  elseif filetype == 'ruby' then
    vim.cmd.VtrSendCommand('bundle exec rubocop ' .. filename)
  else
    print('Não sei rodar um linter para arquivos do tipo ' .. filetype)
  end
end
