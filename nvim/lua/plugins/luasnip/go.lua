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
  s('req', d(1, function()
    local positions = vim.fn.getpos('.')
    local line_nr = positions[2]
    local line_up_to_cursor = vim.fn.getline(line_nr):sub(1, positions[3])

    if line_up_to_cursor:match('^%s*$') then
      return sn(nil, c(1, {
        fmt('{}require(\'{}\')',
        {
          d(1, function (args)
            local import_name =
                args[1][1]
                :gsub('.*%.(.*)$', '%1')
                :gsub('%s*$', '') -- remove trailing whitespace
                :gsub('^%s*', '') -- remove leading whitespace
                :gsub('-', '_')
                :gsub('%s', '_')
                :lower()

            return sn(nil, fmt('local {} = ', t(import_name)))
          end, { 2, }),
          i(2),
        }),
        fmt('require(\'{}\')', { i(1), }),
      }))
    end

    return sn(nil, fmt('require(\'{}\')', { i(1), }))
  end, {})),

  -- if else elseif
  s('if', fmt('if {} then\n\t{}{}{}\nend', {
    i(1),
    i(2),
    c(4, {
      t(''),
      fmt('\n\nelseif {} then\n\t{}\n', { i(1), i(2), }),
    }),
    c(3, {
      t(''),
      fmt('\n\nelse\n\t{}\n', { i(1), }),
    })
  })),

  -- function
  s('func', fmt('{}({})\n\t{}\nend', {
    d(1, function()
      -- Subtract 2 because this snippet is "2 lines tall".
      -- The getpos('.') and getline('.') gives info about the end
      -- of the snippet, so in this case, when we subtract 2 we get
      -- the info about the start of the snippet.
      local positions = vim.fn.getpos('.')
      local line_nr = positions[2] - 2
      local line_up_to_cursor = vim.fn.getline(line_nr):sub(1, positions[3])

      if line_up_to_cursor:match('[%w=]') then
        return sn(nil, t('function '))
      end

      return sn(
        nil,
        c(1, {
          fmt('local function {}', { i(1), }),
          fmt('function {}', { i(1), }),
        }))
    end, {}),
    i(2), i(3),
  })),

  -- for
  s('for', fmt('for {} in {} do\n\t{}\nend', { i(1), i(2), i(3), })),
})

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

-- use in lua files the snippets defined for go and java
-- luasnip.filetype_extend('lua', { 'go', 'java', })

-----------------------------------------------
-- Some go examples without the fmt function --
-----------------------------------------------

-- s('ier', { -- if error not nil
--   t('if '),
--   i(2, 'err != nil'),
--   t({ ' {', '\t', }),
--   i(1),
--   t({ '', '}' })
-- }),

-- {
--   t('func '),
--   i(1),
--   t({ '(w http.ResponseWriter, r *http.Request) {', '\t', }),
--   i(2),
--   t({ '', '}' }),
-- }),

-- { -- function
--   i(0),
--   t('func '),
--   i(1),
--   t('('),
--   i(2),
--   t(')'),
--   i(3, ' '),
--   t({ '{', '\t', }),
--   i(4),
--   t({ '', '}' }),
-- }),
