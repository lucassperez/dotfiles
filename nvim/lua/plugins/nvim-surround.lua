require('nvim-surround').setup({
  move_cursor = false,
  aliases = {
    ['p'] = ')',
  },
})

vim.cmd('hi NvimSurroundHighlightTextObject gui=NONE')
