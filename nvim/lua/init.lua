-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

-- Sobre as cores:
-- https://icyphox.sh/blog/nvim-lua/
require('keymappings')
require('settings')

require('plugins')
require('plugins.lsp')
require('plugins.tree-sitter')
require('plugins.tree-sitter.elixir')
require('plugins.tree-sitter.typescript')
-- require('plugins.compe')
require('plugins.cmp')
require('plugins.nvim-autopairs')
require('plugins.lualine')
require('plugins.Comment')
-- require('plugins.buftabline')
require('plugins.barbar')
-- require('plugins.tokyonight')
require('plugins.telescope')

-- Meus próprios scritpts
require('helper-scripts.vtr.test')
require('helper-scripts.vtr.linter')
require('helper-scripts.vtr.from-git-generic')
require('helper-scripts.vtr.execute-script')
require('helper-scripts.vtr.send-line-to-tmux')
require('helper-scripts.togglebetweentestandfile')
require('helper-scripts.write-debugger-breakpoint')

-- Useful to print tables
function P(value)
  print(vim.inspect(value))
  return value
end
