-- vim.lsp.set_log_level('debug')
-- Ver isso depois? https://github.com/ray-x/lsp_signature.nvim

require('plugins.lsp.elixir')
require('plugins.lsp.typescript')
-- The golang language server gopls looks for .git or go.mod file to start
require('plugins.lsp.go')
-- Looks for .git or a Gemfile
require('plugins.lsp.ruby')
require('plugins.lsp.css')
require('plugins.lsp.clojure')
require('plugins.lsp.markdown')
