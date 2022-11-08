vim.g.catppuccin_flavour = 'frappe' -- latte, frappe, macchiato, mocha

require('catppuccin').setup({
  transparent_background = true,
  styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
      },
      underlines = {
        errors = { 'underline' },
        hints = { 'underline' },
        warnings = { 'underline' },
        information = { 'underline' },
      },
    },
    cmp = true,
    telescope = true,
    nvimtree = false,
  },
  custom_highlights = function(colors)
    return {
      CursorLine  = { bg = '#3a3b3c' },
      ColorColumn = { bg = '#4e4e4e' },
      Pmenu       = { bg = '#090d24' },
      NormalFloat = { bg = '#090d24' },
      Visual      = { bg = '#61677d',  style = { 'bold' } },

      CursorLineNr = { fg = '#e2e209' },
      SignColumn   = { fg = '#a8a8a8' },
      LineNr       = { fg = '#8a8a8a' },
      Comment      = { fg = '#aaaaaa' },
      NonText      = { fg = '#729ecb',  style = { 'bold' } },
      VertSplit    = { fg = 'NONE',     style = { 'reverse' } },
      StatusLine   = { fg = 'NONE',     style = { 'bold', 'reverse' } },
      StatusLineNC = { fg = 'NONE',     style = { 'reverse' } },
      MoreMsg      = { fg = 'SeaGreen', style = { 'bold' } },
      MatchParen   = { fg = '#87ff00',   style = { 'bold' } },
    }
  end,
})

vim.cmd([[
colorscheme catppuccin
hi clear EndOfBuffer
hi link EndOfBuffer NonText
hi clear MsgSeparator
hi link MsgSeparator StatusLine
match CustomTabs /\t/
hi CustomTabs guifg=#999999 gui=NONE
match CustomTrailingWhiteSpaces /\s\+$/
hi link CustomTrailingWhiteSpaces NonText
" Serring ['@parameter'] = { style = {} } would clear
" everything else and leave it without colors
hi @parameter gui=NONE cterm=NONE
hi @namespace gui=NONE cterm=NONE
]])

--[[
Talvez mudar esses também?
Search
Visual
]]
