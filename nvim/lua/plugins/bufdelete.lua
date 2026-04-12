return {
  {
    mode = 'n',
    lhs = '<leader>d',
    rhs = ':Bdelete<CR>',
    opts = {
      desc = '[Bufdelete] Fecha o buffer atual',
    },
  },
  {
    mode = 'n',
    lhs = '<A-D>',
    rhs = ':Bdelete<CR>',
    opts = {
      desc = '[Bufdelete] Fecha o buffer atual',
    },
  },
}
