-- https://github.com/elixir-lsp/elixir-ls#building-and-running
-- The ElixirLS must be installed for this to work.

-- https://elixirforum.com/t/neovim-nvim-lsp-elixir/31230/11
-- A callback that will get called when a buffer connects to the language server.
-- Here we create any key maps that we want to have on that buffer.
local on_attach = function(client, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = { noremap = true, silent = true }

  map('n', [[\f]], ':lua vim.lsp.buf.format({async=true})<CR>', map_opts)
  map('n', 'K',    ':lua vim.lsp.buf.definition()<CR>', map_opts)
  map('n', [[\k]], ':lua vim.lsp.buf.hover()<CR>', map_opts)
  -- map('n', [[\K]], ':lua vim.lsp.buf.signature_help()<CR>', map_opts)
  map('n', '[d',   ':lua vim.diagnostic.goto_prev()<CR>', map_opts)
  map('n', ']d',   ':lua vim.diagnostic.goto_next()<CR>', map_opts)
  map('n', [[\d]], ':lua vim.diagnostic.open_float()<CR>', map_opts)

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

require('lspconfig').elixirls.setup({
  cmd = { '/home/lucas/sources/elixir-ls/release-directory/language_server.sh' };
  on_attach = on_attach,
  capabilities = {},
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false,
      -- enableTestLenses = true, -- I have no idea what this does
    }
  }
})

-- vim.lsp.set_log_level('debug')

-- Random references
-- https://www.mitchellhanberg.com/how-to-set-up-neovim-for-elixir-development/
-- https://davelage.com/posts/neovim-0.5-lsp-elixirls/
