-- vim.opt if for things you would `set` in vimscript. vim.g is for things you'd `let`.

-- Sobre as cores:
-- https://icyphox.sh/blog/nvim-lua/
require('keymappings')
require('settings')

require('pluggins.lsp')
require('pluggins.tree-sitter.config')
require('pluggins.tree-sitter.elixir')
require('pluggins.completion')
require('pluggins.my-lualine')

-- Meus próprios scritpts
require('filetype-tmux-runners.test')
require('filetype-tmux-runners.linter')
