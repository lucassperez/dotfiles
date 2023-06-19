-- :h new-filetype
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', }, {
  callback = function()
    -- if vim.bo.ft == '' then vim.bo.ft = 'template' end
    -- The setfiletype does not overwrite
    -- the filetype if it was detected.
    -- It is like the if above.
    vim.cmd.setfiletype('template')
  end,
  pattern = '*.gohtml',
})
