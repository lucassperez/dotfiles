-- Markdown Language Server

-- https://github.com/artempyanykh/marksman/releases
-- Download a binary and put it on PATH
local function on_attach(client, bufnr)
  local map = vim.keymap.set
  local map_opts = { noremap = true, buffer = bufnr }

  -- I have no idea what works and what doesn't for the marksman server
  -- https://github.com/artempyanykh/marksman#features-and-plans
  map('n', '\\f', function() vim.lsp.buf.format({ async = true }) end, map_opts)
  map('n', 'K',   function() vim.lsp.buf.definition() end, map_opts)
  map('n', '\\k', function() vim.lsp.buf.hover() end, map_opts)
  map('n', '\\n', function() vim.lsp.buf.rename() end, map_opts)
  map('n', '\\r', function() require('telescope.builtin').lsp_references() end, map_opts)
  map('n', '\\d', function() vim.diagnostic.open_float() end, map_opts)
  map('n', '[d',  function()
    local should_center = vim.diagnostic.get_prev({ wrap = false })
    vim.diagnostic.goto_prev({ wrap = false })
    if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
  end, map_opts)
  map('n', ']d',  function()
    local should_center = vim.diagnostic.get_next({ wrap = false })
    vim.diagnostic.goto_next({ wrap = false })
    if should_center then vim.api.nvim_feedkeys('zz', 'n', false) end
  end, map_opts)

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

return {
  on_attach = on_attach,
}
