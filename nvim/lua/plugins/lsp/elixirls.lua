-- Elixir Language Server

return {
  -- cmd = { '/home/lucas/sources/elixir-ls/release-directory/language_server.sh' };
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false,
      -- enableTestLenses = true, -- I have no idea what this does
    }
  }
}

-- vim.lsp.set_log_level('debug')

-- Random references
-- https://www.mitchellhanberg.com/how-to-set-up-neovim-for-elixir-development/
-- https://davelage.com/posts/neovim-0.5-lsp-elixirls/
