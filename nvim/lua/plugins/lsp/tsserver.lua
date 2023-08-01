-- Typescript Language Server

-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c

-- npm i -g typescript-language-server
-- Também tem que ter o próprio typescript instalado, tipo com npm i -g typescript
-- Também deveria instalar o eslint_d com npm i -g eslint_d

-- New ts utils. The old nvim-lsp-ts-utils is no longer maintained, and the
-- author made this instead: https://github.com/jose-elias-alvarez/typescript.nvim
local typescript = require('typescript')

local defaults = require('plugins.lsp.defaults')

local on_attach = function(client, bufnr)
  defaults.keymaps(bufnr)

  local function map(lhs, rhs, command, description)
    local map_opts = { noremap = true, buffer = bufnr, }
    if description then map_opts.desc = 'LSP: ' .. description end
    vim.keymap.set(lhs, rhs, command, map_opts)
  end

  vim.keymap.set('n', '\\f', function()
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
    vim.lsp.buf.format({ async = true })
  end, { noremap = true, buffer = bufnr, desc = 'LSP: Formata o buffer atual', })

  vim.keymap.set('n', '\\I', function()
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
  end, { noremap = true, buffer = bufnr, desc = 'LSP: Organiza os imports', })

  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   callback = vim.lsp.format,
  --   desc = 'LSP: Formats the buffer before write with tsserver',
  -- })

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'LSP: Formata o buffer atual e organiza os imports', })

  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   command = 'Format',
  --   desc = 'LSP: Formats the buffer before write with tsserver (Format user command)',
  -- })

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
