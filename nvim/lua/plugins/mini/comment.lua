require('mini.comment').setup({
  options = {
    ignore_blank_line = true,
  },
  mappings = {
    -- I installed this plugin in place of
    -- Comment.nvim solely because of this.
    textobject = 'gc',
  }
})
