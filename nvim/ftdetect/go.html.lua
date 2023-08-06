-- :h new-filetype
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    -- I want to override the filetype, because
    -- by default it is going to be html.
    vim.bo.ft = 'template'
  end,
  pattern = '*.go.html',
  desc = 'Set template filetype for files matching *.go.html',
})
