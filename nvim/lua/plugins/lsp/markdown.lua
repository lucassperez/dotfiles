-- https://github.com/artempyanykh/marksman/releases
-- Download a binary and put it on PATH
local function on_attach(client, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = { noremap = true, silent = true }
  -- I have no idea what works and what doesn't for the marksman server
  -- https://github.com/artempyanykh/marksman#features-and-plans
  map('n', [[\f]], ':lua vim.lsp.buf.format({async=true})<CR>', map_opts)
  map('n', 'K',    ':lua vim.lsp.buf.definition()<CR>', map_opts)
  map('n', [[\k]], ':lua vim.lsp.buf.hover()<CR>', map_opts)
  -- map('n', [[\K]], ':lua vim.lsp.buf.signature_help()<CR>', map_opts)
  map('n', [[\n]], ':lua vim.lsp.buf.rename()<CR>', map_opts) -- this is so nice
  -- map('n', [[\r]], ':lua vim.lsp.buf.references()<CR>', map_opts)
  map('n', [[\r]], ":lua require('telescope.builtin').lsp_references()<CR>", map_opts)
  -- map('n', [[\i]], ':lua vim.lsp.buf.implementation()<CR>', map_opts)
  map('n', '[d',   ':lua vim.diagnostic.goto_prev()<CR>', map_opts)
  map('n', ']d',   ':lua vim.diagnostic.goto_next()<CR>', map_opts)
  map('n', [[\d]], ':lua vim.diagnostic.open_float()<CR>', map_opts)

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

require('lspconfig').marksman.setup({
  on_attach = on_attach,
})
