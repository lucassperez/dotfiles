return {
  tag = '[Telescope]',
  lazyPluginSpec = require('plugins.FUZZY_FINDER.telescope.lazy-plugin-spec'),

  diagnostics = function()
    require('telescope.builtin').diagnostics()
  end,

  lsp_definition = function()
    require('telescope.builtin').lsp_definitions()
  end,

  lsp_references = function()
    require('telescope.builtin').lsp_references()
  end,

  lsp_implementation = function()
    require('telescope.builtin').lsp_implementations()
  end,
}
