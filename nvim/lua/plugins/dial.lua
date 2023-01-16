local augend = require('dial.augend')

-- local function ftBools()
--   local filetype = vim.bo.filetype
--   if filetype == 'python' then
--     return { 'True', 'False', 'None' }
--   elseif filetype == 'javascript'
--       or filetype == 'javascriptreact'
--       or filetype == 'typescript'
--       or filetype == 'typescriptreact'
--   then
--     return { 'true', 'false', 'undefined', 'null' }
--   else
--     return { 'true', 'false', 'nil' }
--   end
-- end

require('dial.config').augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.date.alias['%Y/%m/%d'],
    augend.constant.new({
      elements = { 'true', 'false', 'nil' },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { 'and', 'or' },
      word = true,
      cyclic = true,
    }),
    augend.integer.new({
      radix = 16,
      prefix = '#',
      natural = true,
    }),
    augend.integer.new({
      radix = 16,
      prefix = '0x',
      natural = true,
    }),
  },
})

-- These map functions return a string, so I have
-- to concatenate another string if I want to do
-- something else after these actions.
local dial_map = require('dial.map')
vim.keymap.set('n', '<C-a>', dial_map.inc_normal(), { noremap = true })
vim.keymap.set('n', '<C-x>', dial_map.dec_normal(), { noremap = true })
vim.keymap.set('v', '<C-a>', dial_map.inc_visual() .. 'gv', { noremap = true })
vim.keymap.set('v', '<C-x>', dial_map.dec_visual() .. 'gv', { noremap = true })
vim.keymap.set('v', 'g<C-a>', dial_map.inc_gvisual() .. 'gv', { noremap = true })
vim.keymap.set('v', 'g<C-x>', dial_map.dec_gvisual() .. 'gv', { noremap = true })
