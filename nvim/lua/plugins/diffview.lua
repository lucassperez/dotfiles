local function init()
  vim.keymap.set('n', '<leader>çs', ':DiffviewOpen<CR>', { desc = '[Diffview] Abre o diffview' })
  vim.keymap.set('n', '<leader>çh', ':DiffviewFileHistory<CR>', { desc = '[Diffview] Abre o diffview/file_history' })
end

local function setup()
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
end

return {
  init = init,
  setup = setup,
  cmd = {
    'DiffviewClose',
    'DiffviewFileHistory',
    'DiffviewFocusFiles',
    'DiffviewLog',
    'DiffviewOpen',
    'DiffviewRefresh',
    'DiffviewToggleFiles',
    'DiffviewClose',
  },
}
