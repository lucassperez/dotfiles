local ts = require('nvim-treesitter')

ts.setup({
  install_dir = vim.fn.stdpath('data') .. '/tree-sitter'
})

ts.install({
  'lua',
  'comment',
  'vim',
  'vimdoc',
  'bash',
  'query',
})

local text_objects_configs = require('plugins.nvim-treesitter-textobjects')
text_objects_configs.setup()
text_objects_configs.create_keymaps()

vim.api.nvim_create_autocmd('FileType', {
  callback = function (ev)
    pcall(vim.treesitter.start, ev.buf)
  end
})

vim.api.nvim_create_user_command('TSListInstalled', function ()
  return P(ts.get_installed())
end, {})

vim.api.nvim_create_user_command('TSPlayground', function ()
  vim.cmd.InspectTree()
  print('Trivia: O novo TSPlayground é chamado InspectTree')
end, {})

--[[
Comandos:
zc - close current fold
zo - open current fold
zM - close all folds
zR - open all folds
zd - delete fold at cursor
zr - reduce fold level
zm - increase fold level
]]
vim.wo[0][0].foldmethod = 'expr'
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
