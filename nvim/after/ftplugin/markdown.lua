vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'markdown' then
      local win_configs = vim.api.nvim_win_get_config(0)
      local is_float = win_configs.relative == 'win'

      if is_float then vim.wo.concealcursor = 'n' end
    end
  end,
  once = true,
})
