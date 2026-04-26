local function on_attach(_, bufnr)
  local ok = pcall(require, 'stylua')

  if ok then
    local function format()
      require('stylua').format({
        bufnr = bufnr,
        config_path = vim.fn.stdpath('config') .. '/default-stylua.toml',
      })
    end

    local desc = 'LSP: Formata o buffer atual usando stylua'

    vim.keymap.set('n', '\\f', format, { noremap = true, buffer = bufnr, desc = desc })
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', format, { desc = desc })
  end

  -- local root_dir = client.config.root_dir
  -- if root_dir then vim.api.nvim_set_current_dir(root_dir) end
end

local function hook(options)
  require('lazydev').setup({
    library = {
      {
        path = '${3rd}/luv/library',
        words = { 'vim%.uv' },
      },
    },
  })
  options.capabilities.textDocument.completion.completionItem.snippetSupport = false
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
}, hook
