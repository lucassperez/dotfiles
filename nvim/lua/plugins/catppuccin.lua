local my_flavour = 'frappe'
vim.g.catppuccin_flavour = my_flavour -- latte, frappe, macchiato, mocha

-- local my_colors_palette = require('catppuccin.palettes').get_palette(my_flavour)
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
    local custom_highlights_table = {
      CursorLine  = { bg = '#3a3b3c' },
      ColorColumn = { bg = '#4e4e4e' },
      Pmenu       = { bg = '#090d24' },
      NormalFloat = { bg = '#090d24' },
      Visual      = { bg = '#61677d',  style = { 'bold' } },
      HighlightOnYank = { bg = '#71778d' }, -- see settings for this

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

      -- Search       = { fg='#c6d0f5', bg='#506373' },
      -- CurSearch    = { fg='#506373', bg='#c6d0f5' },
    }
    -- if vim.bo.filetype == 'elixir' then
    --   local my_colors_palette = require('catppuccin.palettes').get_palette(my_flavour)
    --   custom_highlights_table['@function'] = { fg = my_colors_palette.yellow }
    --   custom_highlights_table['@method']   = { fg = my_colors_palette.yellow }
    --   custom_highlights_table['@type']     = { fg = my_colors_palette.blue }
    -- end
    return custom_highlights_table
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
" Setting ['@parameter'] = { style = {} } would clear
" everything else and leave it without colors
hi @parameter gui=NONE cterm=NONE
hi @namespace gui=NONE cterm=NONE

" I don't want to use after/syntax/elixir.vim to change these
" because I only want to do it when using catppuccin
" hi link elixirAlias @type
" hi link elixirExUnitAssert elixirFunctionDeclaration
" hi link elixirFunctionDeclaration @function

" hi DiffAdd    guibg=NONE
" hi DiffChange guibg=NONE
" hi DiffDelete guibg=NONE
" hi DiffText   guibg=NONE
]])

--[[
Talvez mudar esses também?
Search
Visual
]]
