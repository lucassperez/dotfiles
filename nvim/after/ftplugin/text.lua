vim.wo.wrap = true
vim.notify('Em arquivo do tipo text, mudamos pra wrap = true!', vim.log.levels.INFO)
vim.wo.breakindent = true
vim.wo.linebreak = true
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
