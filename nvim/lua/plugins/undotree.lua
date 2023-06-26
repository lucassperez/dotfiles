vim.keymap.set(
  'n',
  '<leader>u',
  function()
    vim.cmd.UndotreeToggle()
    vim.cmd.UndotreeFocus()
    print('Toggling Undo Tree')
  end,
  { noremap = true, silent = false, desc = 'Abre a árvore de desfazer (undotree)', }
)
