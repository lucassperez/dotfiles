local luasnip = require('luasnip')

local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
-- local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
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

luasnip.add_snippets('lua', {
  s(
    'req',
    d(1, function()
      local positions = vim.fn.getpos('.')
      local line_nr = positions[2]
      local line_up_to_cursor = vim.fn.getline(line_nr):sub(1, positions[3])

      if line_up_to_cursor:match('^%s*$') then
        return sn(
          nil,
          c(1, {
            fmt("{}require('{}')", {
              d(1, function(args)
                local import_name = args
                  [1]
                  [1]
                  :gsub('.*%.(.*)$', '%1')
                  :gsub('%s*$', '') -- remove trailing whitespace
                  :gsub('^%s*', '') -- remove leading whitespace
                  :gsub('-', '_')
                  :gsub('%s', '_')
                  :lower()

                return sn(nil, fmt('local {} = ', t(import_name)))
              end, { 2 }),
              i(2),
            }),
            fmt("require('{}')", { i(1) }),
          })
        )
      end

      return sn(nil, fmt("require('{}')", { i(1) }))
    end, {})
  ),

  -- if else elseif
  s(
    'if',
    fmt('if {} then\n\t{}{}{}\nend', {
      i(1),
      i(2),
      c(4, {
        t(''),
        fmt('\n\nelseif {} then\n\t{}\n', { i(1), i(2) }),
      }),
      c(3, {
        t(''),
        fmt('\n\nelse\n\t{}\n', { i(1) }),
      }),
    })
  ),

  -- function
  s(
    'func',
    fmt('{}({})\n\t{}\nend', {
      d(1, function()
        -- Subtract 2 because this snippet is "2 lines tall".
        -- The getpos('.') and getline('.') gives info about the end
        -- of the snippet, so in this case, when we subtract 2 we get
        -- the info about the start of the snippet.
        local positions = vim.fn.getpos('.')
        local line_nr = positions[2] - 2
        local line_up_to_cursor = vim.fn.getline(line_nr):sub(1, positions[3])

        if line_up_to_cursor:match('[%w=]') then return sn(nil, t('function ')) end

        return sn(
          nil,
          c(1, {
            fmt('local function {}', { i(1) }),
            fmt('function {}', { i(1) }),
          })
        )
      end, {}),
      i(2),
      i(3),
    })
  ),

  -- for
  s('for', fmt('for {} in {} do\n\t{}\nend', { i(1), i(2), i(3) })),
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
