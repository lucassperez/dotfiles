require('diffview').setup({
  use_icons = false, -- Fuck web devicons
  signs = {
    fold_closed = '> ',
    fold_open = 'v ',
    done = '✓',
  },
})

vim.cmd([[
hi DiffviewNonText guifg=#729ecb
]])

vim.api.nvim_create_user_command('DiffviewMyToggle', function()
  local views = require('diffview.lib').views

  if #views <= 0 then
    vim.cmd.DiffviewOpen()
    return
  end

  local current_tab = vim.api.nvim_get_current_tabpage()

  for _, view in ipairs(views) do
    if view.tabpage == current_tab then
      vim.cmd.DiffviewClose()
      return
    end
  end

  vim.api.nvim_set_current_tabpage(views[1].tabpage)
end, {})

vim.keymap.set('n', ',cv', ':DiffviewMyToggle<CR>', { desc = '[Diffview] Toggle Diffview' })
