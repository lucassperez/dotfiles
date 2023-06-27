local luasnip = require('luasnip')

local s = luasnip.snippet
-- local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
-- local f = luasnip.function_node
local c = luasnip.choice_node
-- local d = luasnip.dynamic_node
-- local r = luasnip.restore_node
-- local l = require('luasnip.extras').lambda
-- local rep = require('luasnip.extras').rep
-- local p = require('luasnip.extras').partial
-- local m = require('luasnip.extras').match
-- local n = require('luasnip.extras').nonempty
-- local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local types = require('luasnip.util.types')
-- local conds = require('luasnip.extras.conditions')
-- local conds_expand = require('luasnip.extras.conditions.expand')

-- I made this a plain variable, but then I could
-- only use it once for some misterious reason. D:!
local function go_error_snippet()
  return fmt(
    'if {} {{{}\n\t{}\n}}',
    { i(3, 'err != nil'), i(2), c(1, {
      fmt('{}return fmt.Errorf("{}: %w", err)', { i(2), i(1), }),
      t('panic(err)'),
      i(1),
    }), })
end

luasnip.add_snippets('go', {
  -- if error
  s('ier', go_error_snippet()),
  s('ife', go_error_snippet()),

  -- http handler args
  s('wr', { t('w http.ResponseWriter, r *http.Request'), }),

  -- function + http handler args
  s('fh', fmt('func {}(w http.ResponseWriter, r *http.Request) {{\n\t{}\n}}', { i(1), i(2), })),

  -- function
  s('func',
    fmt('func {}({}){}{{\n\t{}\n}}', {
      c(1, { i(1), fmt('({}) {}', { i(1), i(2), }) }), -- choice for functions or methods
      i(2), i(3, ' '), i(4),
    })),

  -- TODO aprender a fazer isso
  -- s('for', fmt('for {} {{\n\t{}\n}}', {
  --   c(1, {
  --     fmt('{}; {}; {}', {
  --       i(1),
  --       f(function(var_name) return (var_name[1][1]):gsub('(%w*)%s:=.*', '%1') end, { 1, }),
  --       f(function(var_name) return (var_name[1][1]):gsub('(%w*)%s:=.*', '%1') end, { 1, })
  --     }),
  --     i(1),
  --   }),
  --   i(2),
  -- })),
})

-----------------------------------
-- Old smart lua require with state
-----------------------------------

-- local function smartRequire()
--   return d(1, function(args, _, old_state)
--     old_state = old_state or {
--       need_smart_var_name = 'not yet defined',
--       line_up_to_cursor = nil,
--       pad = nil,
--     }

--     if not old_state.line_up_to_cursor then
--       local positions = vim.fn.getpos('.')
--       local line_nr = positions[2]
--       old_state.line_up_to_cursor = vim.fn.getline(line_nr):sub(1, positions[3])
--     end

--     if old_state.need_smart_var_name == 'not yet defined' then
--       if old_state.line_up_to_cursor:match('=') then
--         old_state.need_smart_var_name = false
--       else
--         old_state.need_smart_var_name = true
--       end
--     end

--     if not old_state.need_smart_var_name and not old_state.pad then
--       if old_state.line_up_to_cursor:match('=%s') then
--         old_state.pad = ''
--       else
--         old_state.pad = ' '
--       end
--     end

--     local snip

--     if old_state.need_smart_var_name then
--       local import_name =
--       args[1][1]
--       :gsub('.*%.(.*)$', '%1')
--       :gsub('%s*$', '') -- remove trailing whitespace
--       :gsub('^%s*', '') -- remove leading whitespace
--       :gsub('-', '_')
--       :gsub('%s', '_')
--       :lower()

--       snip = sn(nil, fmt('local {} = ', t(import_name)))
--     else
--       snip = sn(nil, t(old_state.pad))
--     end

--     snip.old_state = old_state
--     return snip
--   end, { 2, }),
--   i(2)
-- end
