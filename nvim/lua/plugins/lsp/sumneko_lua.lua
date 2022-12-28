-- Lua Language Server

return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'awesome', },
      },
      workspace = {
      --   library = vim.api.nvim_get_runtime_file('', true),
        checkThirdPart = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
