-- Elixir Language Server

return {
  -- cmd = { '/path/of/the/binary/elixir-ls/release-directory/language_server.sh' };
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false,
      -- enableTestLenses = true, -- I have no idea what this does
    },
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { stylize_markdown = false, }),
  },
}

-- vim.lsp.set_log_level('debug')

-- Random references
-- https://www.mitchellhanberg.com/how-to-set-up-neovim-for-elixir-development/
-- https://davelage.com/posts/neovim-0.5-lsp-elixirls/
