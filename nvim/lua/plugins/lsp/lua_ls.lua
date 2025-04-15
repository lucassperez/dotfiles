-- Lua Language Server

local function on_attach(client, bufnr)
  require('plugins.lsp.defaults').keymaps(bufnr)

  local ok = pcall(require, 'stylua')

  if ok then
    vim.keymap.set('n', '\\f', function()
      require('stylua').format({
        bufnr = bufnr,
        config_path = vim.fn.stdpath('config') .. '/default-stylua.toml',
      })
    end, { noremap = true, buffer = bufnr, desc = 'LSP: Formata o buffer atual usando stylua' })

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
      require('stylua').format({
        bufnr = bufnr,
        config_path = vim.fn.stdpath('config') .. '/default-stylua.toml',
      })
    end, { desc = 'LSP: Formata o buffer atual usando stylua' })
  end

  -- local root_dir = client.config.root_dir
  -- if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

return {
  on_attach = on_attach,
  -- How can I disable language server's snippets?
  -- This is not working.
  -- capabilities = {
  --   textDocument = {
  --     completion = {
  --       completionItem = {
  --         snippetSupport = false,
  --       },
  --     },
  --   },
  -- },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'awesome' },
      },
      workspace = {
        ignoreDir = { vim.fn.stdpath('config') .. '/undodir' },
        --   library = vim.api.nvim_get_runtime_file('', true),
        --   -- library = vim.env.VIMRUNTIME,
        --   checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
