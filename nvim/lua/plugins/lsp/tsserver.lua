-- Typescript Language Server

-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c

-- npm i -g typescript-language-server
-- Também tem que ter o próprio typescript instalado, tipo com npm i -g typescript
-- Também deveria instalar o eslint_d com npm i -g eslint_d

-- New ts utils. The old nvim-lsp-ts-utils is no longer maintained, and the
-- author made this instead: https://github.com/jose-elias-alvarez/typescript.nvim
local typescript = require('typescript')

local on_attach = function(client, bufnr)
  local map = vim.keymap.set
  local map_opts = { noremap = true, buffer = bufnr }

  map('n', '\\f', function()
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
    vim.lsp.buf.format({ async = true })
  end, map_opts)

  map('n', '\\I', function()
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
  end, map_opts)

  map('n', 'K',   function() vim.lsp.buf.definition() end, map_opts)
  map('n', '\\k', function() vim.lsp.buf.hover() end, map_opts)
  map('n', '\\n', function() vim.lsp.buf.rename() end, map_opts)

  map('n', '\\r', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
      telescope.lsp_references()
    else
      print('Telescope not found, using standard neovim functions')
      vim.lsp.buf.references({})
    end
  end, map_opts)

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

  map('n', '\\D', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
      telescope.diagnostics()
    else
      print('Telescope not found, using standard neovim functions')
      vim.diagnostic.open_float()
    end
  end, map_opts)

  map('n', '\\i', function() vim.lsp.buf.implementation() end, map_opts)

  -- vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.format()')

  local root_dir = client.config.root_dir
  if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

-- local null_ls = require('null-ls')
-- null_ls.setup({
--   sources = {
--     -- null_ls.builtins.diagnostics.eslint,
--     null_ls.builtins.diagnostics.eslint_d,
--     null_ls.builtins.code_actions.eslint,
--     null_ls.builtins.formatting.prettier
--   },
--   on_attach = on_attach
-- })

return {
  on_attach = on_attach
}
