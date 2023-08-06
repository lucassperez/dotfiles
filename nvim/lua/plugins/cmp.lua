vim.o.completeopt = 'menu,menuone,noselect'

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

-- I can't seem to disable them in LSP itself
-- This doesn't work:
-- https://neovim.discourse.group/t/how-to-disable-lsp-snippets/922/5
local function filter_lsp_snippets(entry)
  if vim.bo.filetype == 'lua' then return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind() end
  return true
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Accept currently selected item. Set `select` to `false`
    -- to only confirm explicitly selected items.
    -- Getting tired of not being able to press enter to go to the
    -- next line when there are auto completion options avaiable,
    -- which is pretty much always. I know I can just ALT_o in
    -- insert mode, but I prefer to just Enter away. F this.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),

    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    -- Order matters here,
    -- top sources have higher priorities
    { name = 'path', trailing_slash = true },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp', entry_filter = filter_lsp_snippets },
    { name = 'buffer', keyword_length = 2 },
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
        luasnip = '[LuaSnip]',
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
    entries = 'custom',
  },
})
