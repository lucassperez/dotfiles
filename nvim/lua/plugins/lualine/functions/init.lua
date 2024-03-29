return {
  getlines = function()
    return '%l/%L:%v'
  end,
  getfile = function()
    return '%f%m%r%h%w'
  end,
  mode = require('plugins.lualine.functions.custom_modes'),
  lsp = require('plugins.lualine.functions.lsp_clients_names'),
  diff = require('plugins.lualine.functions.gitsigns_or_builtin_diff'),
  diagnostics = require('plugins.lualine.functions.diagnostics'),
}
