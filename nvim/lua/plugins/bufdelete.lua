return {
  {
    mode = 'n',
    '<leader>d',
    function()
      require('bufdelete').bufdelete(0)
      print(':Bdelete')
    end,
    desc = '[Bufdelete] Fecha o buffer atual',
  },
  {
    mode = 'n',
    '<A-D>',
    function()
      require('bufdelete').bufdelete(0)
      print(':Bdelete')
    end,
    desc = '[Bufdelete] Fecha o buffer atual',
  },
}
