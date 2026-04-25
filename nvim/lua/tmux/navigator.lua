local function navigate(direction, tmux_direction)
  local before = vim.api.nvim_get_current_win()

  vim.cmd.wincmd(direction)

  local after = vim.api.nvim_get_current_win()

  if after == before then
    vim.fn.system('tmux select-pane ' .. tmux_direction)
  end
end

vim.keymap.set('n', '<C-h>', function () navigate('h', '-L') end)
vim.keymap.set('n', '<C-j>', function () navigate('j', '-D') end)
vim.keymap.set('n', '<C-k>', function () navigate('k', '-U') end)
vim.keymap.set('n', '<C-l>', function () navigate('l', '-R') end)
