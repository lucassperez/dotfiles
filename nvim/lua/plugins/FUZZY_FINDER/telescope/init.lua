return {
  tag = '[Telescope]',
  project_picker = require('plugins.FUZZY_FINDER.telescope.project'),
  lazyPluginSpec = require('plugins.FUZZY_FINDER.telescope.config').lazyPluginSpec,

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
