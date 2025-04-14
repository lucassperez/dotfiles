return {
  tag = '[FzfLua]',
  project_picker = require('plugins.FUZZY_FINDER.fzf-lua.project'),
  lazyPluginSpec = require('plugins.FUZZY_FINDER.fzf-lua.config').lazyPluginSpec,

  diagnostics = function()
    require('fzf-lua').diagnostics_workspace({ jump1 = false })
  end,

  lsp_definition = function()
    require('fzf-lua').lsp_definitions({ jump1 = true })
  end,

  lsp_references = function()
    -- Just for the record that ignore_current_line is a possible argument
    require('fzf-lua').lsp_references({
      jump1 = false,
      ignore_current_line = false,
    })
  end,

  lsp_implementation = function()
    require('fzf-lua').lsp_implementations({ jump1 = false })
  end,

  code_action = function()
    require('fzf-lua').lsp_code_actions()
  end,
}
