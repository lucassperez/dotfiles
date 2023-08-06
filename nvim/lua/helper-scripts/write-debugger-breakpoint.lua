function WriteDebuggerBreakpoint(above)
  local filetype = vim.bo.filetype

  if filetype == '' then
    print('File without filetype not supported')
    return
  end

  local debugger_commands = {
    elixir = 'require IEx; IEx.pry()',
    ruby = 'binding.pry',
  }

  if not debugger_commands[filetype] then
    print('Filetype ' .. filetype .. ' not supported')
    return
  end

  if above then
    vim.cmd('normal O' .. debugger_commands[filetype])
  else
    -- nvim_buf_set_text()
    vim.cmd('normal o' .. debugger_commands[filetype])
  end
  vim.cmd('normal _')
end
