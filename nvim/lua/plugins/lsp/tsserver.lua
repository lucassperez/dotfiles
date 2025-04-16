--[[
The tsserver changed its name to ts_ls
But the typescript.nvim plugin still internally uses tsserver, but it is abandoned.
https://github.com/jose-elias-alvarez/typescript.nvim/issues/80
But anyways, I can probably live without any custom ts_ls config file.
To replace typescript.nvim, this also exists: https://github.com/pmizio/typescript-tools.nvim
Who knows.
]]

--[[
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

  -- local function map(lhs, rhs, command, description)
  --   local map_opts = { noremap = true, buffer = bufnr }
  --   if description then map_opts.desc = 'LSP: ' .. description end
  --   vim.keymap.set(lhs, rhs, command, map_opts)
  -- end

  vim.keymap.set('n', '\\f', function()
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
    vim.lsp.buf.format({ async = true })
  end, { noremap = true, buffer = bufnr, desc = 'LSP: Formata o buffer atual' })

  vim.keymap.set('n', '\\I', function()
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
  end, { noremap = true, buffer = bufnr, desc = 'LSP: Organiza os imports' })

  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   callback = vim.lsp.format,
  --   desc = 'LSP: Formats the buffer before write with tsserver',
  -- })

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(opts)
    -- Call 'Format no_async' to not format asynchronously
    local format_opts = { async = opts.args ~= 'no_async' }
    typescript.actions.addMissingImports()
    typescript.actions.organizeImports()
    vim.lsp.buf.format(format_opts)
  end, {
    desc = 'LSP: Formata o buffer atual e organiza os imports. Format no_async pra formatar sincronamente',
    nargs = '?',
  })

  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   command = 'Format no_async',
  --   desc = 'LSP: Formats the buffer before write with tsserver (It uses Format no_async user command)',
  -- })

  -- local root_dir = client.config.root_dir
  -- if root_dir then vim.api.nvim_set_current_dir(root_dir) end
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
  on_attach = on_attach,
}
]]
