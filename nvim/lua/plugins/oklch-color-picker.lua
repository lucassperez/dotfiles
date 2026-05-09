vim.api.nvim_create_user_command('ColorHighlightToggle', function()
  require('oklch-color-picker').highlight.toggle()
end, {})

vim.keymap.set('n', '<leader>C', ':ColorHighlightToggle<CR>')
vim.keymap.set('n', '<leader>V', ':ColorPickOklch<CR>')

require('oklch-color-picker').setup({
  highlight = {
    -- Don't show highlights automatically when opening
    -- a file, only after activating the highlighs manually.
    enabled = false,
  },
})
