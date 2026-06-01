return {
  set = function()
    vim.keymap.set('n', '<leader>d', ':BDelete<CR>')
    vim.keymap.set('n', '<A-D>', ':BDelete<CR>')

    vim.keymap.set('n', '<A-Q>', ':BMovePrevious<CR>', { desc = '[Tabline] Move o buffer atual para trás na tabline' })
    vim.keymap.set('n', '<A-W>', ':BMoveNext<CR>', { desc = '[Tabline] Move o buffer atual para frente na tabline' })

    vim.keymap.set('n', '<leader>q', ':BPrevious<CR>')
    vim.keymap.set('n', '<leader>w', ':BNext<CR>')

    vim.keymap.set('n', '<A-q>', ':BPrevious<CR>', { desc = 'Mostra o buffer anterior' })
    vim.keymap.set('n', '<A-w>', ':BNext<CR>', { desc = 'Mostra o buffer seguinte' })

    -- Override default mapping
    vim.keymap.set('n', '[b', ':BPrevious<CR>', { silent = true, desc = 'Mostra o buffer anterior' })
    vim.keymap.set('n', ']b', ':BNext<CR>', { silent = true, desc = 'Mostra o buffer seguinte' })
  end,
}
