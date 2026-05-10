require('mini.comment').setup({
  mappings = {
    textobject = '',
  },
  options = {
    ignore_blank_line = true,

    custom_commentstring = function()
      return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
    end,
  },
})

vim.keymap.set('o', 'u', function()
  vim.b.minicomment_config = { options = { ignore_blank_line = false } }
  MiniComment.textobject()
  vim.b.minicomment_config = nil
end)

vim.keymap.set('o', 'U', function()
  vim.b.minicomment_config = { options = { ignore_blank_line = true } }
  MiniComment.textobject()
  vim.b.minicomment_config = nil
end)
