vim.g.catppuccin_flavour = 'macchiato' -- latte, frappe, macchiato, mocha

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
    gitgutter = true,
    telescope = true,
    nvimtree = {
      enabled = true,
      show_root = true,
      transparent_panel = false,
    },
  },
  custom_highlights = function(colors)
    return {
      CursorLine = { bg = '#3a3b3c' },
      Comment = { fg = '#8a8a8a', },
      -- ['@comment'] = { fg = '#a8a8a8', },
      SignColumn = { fg = '#a8a8a8', },
      LineNr = { fg = '#8a8a8a' },
      CursorLineNr = { fg = '#e2e209' },
      -- EndOfBuffer = { fg = '#729ecb', 'bold' },
      -- NonText = { fg = '#729ecb', 'bold' },
      -- VertSplit = { fg = 'NONE' }
      ColorColumn = { bg = '#4e4e4e' },
      Pmenu = { bg = '#090d24' },
      NormalFloat = { bg = '#090d24' },
    }
  end,
})

vim.cmd [[colorscheme catppuccin]]
vim.cmd [[hi NonText     guifg=#729ecb gui=bold]]
vim.cmd [[hi clear EndOfBuffer]]
vim.cmd [[hi link EndOfBuffer NonText]]
vim.cmd [[hi VertSplit   guifg=none gui=reverse]]
vim.cmd [[hi StatusLine    guifg=none gui=bold,reverse]]
vim.cmd [[hi StatusLineNC  guifg=none gui=reverse]]
vim.cmd [[hi clear MsgSeparator]]
vim.cmd [[hi link MsgSeparator StatusLine]]
vim.cmd [[hi MoreMsg guifg=SeaGreen gui=bold]]
vim.cmd [[hi @parameter  gui=none]]
vim.cmd [[
  autocmd VimEnter,WinEnter * match CustomTabsGroup /\t/
  hi CustomTabsGroup guifg=#999999 gui=NONE
]]

--[[
Talvez mudar esses também?
Search
Visual
]]
