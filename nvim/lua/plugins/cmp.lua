vim.o.completeopt = 'menu,menuone,noselect'

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Accept currently selected item. Set `select` to `false`
    -- to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),

    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    -- Order matters here,
    -- top sources have higher priorities
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path', trailing_slash = true },
    { name = 'buffer', keyword_length = 2 },
    -- Maybe start using luasnip and add it here?
  },
  formatting = {
    format = lspkind.cmp_format({
      -- modes: text, text_symbol, symbol_text e symbol
      mode = 'text',
      menu = {
        buffer = '[Buf]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        path = '[Path]',
      },
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
    }),
  },
  view = {
    -- custom, wildmenu or native
    entries = 'custom'
  }
})
