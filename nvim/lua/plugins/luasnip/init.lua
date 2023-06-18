local luasnip = require('luasnip')
local types = require('luasnip.util.types')

require('plugins.luasnip.snippets')

luasnip.config.set_config({
  history = true,
  enable_autosnippets = true,

  update_events = { 'TextChanged', 'TextChangedI', },

  ext_opts = {
    [types.choiceNode] = {
      active = {
        -- Virtual text persists if I exit when it is visible
        -- Very bad ):
        virt_text = { { '«« Choice Node', 'Comment', }, },
      },
    },
  },
})

-- Keymaps

vim.keymap.set({ 'i', 's', }, '<C-j>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ 'i', 's', }, '<C-k>', function()
  if luasnip.jumpable() then
    luasnip.jump(-1)
  end
end, { silent = true })

vim.keymap.set({ 'i', 's', }, '<C-l>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })
