-- async_or_timeout
-- Set true for async, set an integer for timeout in mili seconds
return {
  tag = '[FzfLua]',
  before = require('plugins.fzf-lua.config').before,
  after = require('plugins.fzf-lua.config').after,

  diagnostics = function()
    require('fzf-lua').diagnostics_workspace({ jump1 = false, async_or_timeout = true })
  end,

  lsp_definition = function()
    require('fzf-lua').lsp_definitions({ jump1 = true, async_or_timeout = true })
  end,

  lsp_references = function()
    -- Just for the record that ignore_current_line is a possible argument
    require('fzf-lua').lsp_references({
      jump1 = false,
      ignore_current_line = false,
      async_or_timeout = true,
    })
  end,

  lsp_implementation = function()
    require('fzf-lua').lsp_implementations({ jump1 = false, async_or_timeout = true })
  end,

  code_action = function()
    require('fzf-lua').lsp_code_actions()
  end,
}
