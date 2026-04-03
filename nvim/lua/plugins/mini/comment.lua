require('mini.comment').setup({
  -- Vamos testar com false por um tempo
  ignore_blank_line = false,
  mappings = {
    textobject = 'u',
  },
  options = {
    custom_commentstring = function()
      return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
    end,
  },
})
