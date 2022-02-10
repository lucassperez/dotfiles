vim.o.completeopt = 'menuone,noselect'

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  mapping = {
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),

    -- Accept currently selected item. Set `select` to `false`
    -- to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  sources = {
    -- Order matters here, top sources have
    -- higher priorities
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path', trailing_slash = true },
    { name = 'buffer', keyword_length = 2 },
  },
  formatting = {
    format = lspkind.cmp_format({
      -- symbol_map = {
      --   Text = 'Txt',
      --   Method = 'Met',
      --   Function = 'Fun',
      --   Constructor = 'Con',
      --   Field = 'Field',
      --   Variable = 'Var',
      --   Class = 'Class',
      --   Interface = 'Intrfc',
      --   Module = 'Mod',
      --   Property = 'Prop',
      --   Unit = 'Unit',
      --   Value = 'Val',
      --   Enum = 'Enum',
      --   Keyword = 'Keywrd',
      --   Snippet = 'Snip',
      --   Color = 'Colour',
      --   File = 'File',
      --   Reference = 'Ref',
      --   Folder = 'Dir',
      --   EnumMember = 'EnumMember',
      --   Constant = 'Const',
      --   Struct = 'Struct',
      --   Event = 'Event',
      --   Operator = 'Oprtr',
      --   TypeParameter = 'TypeParam'
      -- },
      mode = 'text',
      -- mode = 'symbol',
      menu = {
        buffer = '[Buf]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        path = '[Path]',
      },
    }),
  },
  view = {
    -- custom, wildmenu or native
    entries = 'custom'
  }
})

vim.cmd([[
highlight CmpItemAbbrMatch      guifg='#0000ff'
highlight CmpItemAbbrMatchFuzzy guifg='#ff0000'
highlight CmpItemKind gui=bold
highlight CmpItemMenu guifg='#00ff00'
]])
