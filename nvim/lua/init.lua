-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

-- Sobre as cores:
-- https://icyphox.sh/blog/nvim-lua/
require('keymappings')
require('settings')

require('plugins')
require('plugins.lsp')
require('plugins.tree-sitter.config')
require('plugins.tree-sitter.elixir')
require('plugins.completion')
require('plugins.nvim-autopairs')
require('plugins.my-lualine')
require('plugins.tabout')
require('plugins.Comment')
require('plugins.buftabline')

-- Meus próprios scritpts
require('vtr-helpers.test')
require('vtr-helpers.linter')
require('vtr-helpers.from-git-generic')
require('vtr-helpers.execute-script')
require('vtr-helpers.send-line-to-tmux')
