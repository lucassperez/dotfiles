local luasnip = require('luasnip')

local s = luasnip.snippet
-- local sn = luasnip.snippet_node
-- local t = luasnip.text_node
local i = luasnip.insert_node
-- local f = luasnip.function_node
-- local c = luasnip.choice_node
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

-- Use in eelixir files the snippets defined for elixir
luasnip.filetype_extend('eelixir', { 'elixir' })
luasnip.filetype_extend('heex', { 'elixir' })

local function pathToPascalCase(path)
  if path == '' then return '' end
  local t = type(path)
  if t ~= 'string' then
    local msg = 'Wrong value passed to pathToPascalCase: ' .. path .. ', of type ' .. t
    return '', msg
  end

  -- local p, changed = string.gsub(path, '^lib/', '')
  -- if changed == 0 then return '', 'Not in ^lib/ style of path' end
  local p = path

  local underline_byte = string.byte('_')
  local slash_byte = string.byte('/')
  local dot_byte = string.byte('.')
  local r = {}
  local next_is_upper = false

  for idx = 1, #p do
    local byte = string.byte(p, idx)
    if next_is_upper and byte >= 97 and byte <= 122 then
      -- Subtracting 32 means going from lowercase to upcase
      -- Code 97 is lowercase "a" and 122 is lowercase "z"
      byte = byte - 32
      next_is_upper = false
    end

    if byte == underline_byte then
      next_is_upper = true
    elseif byte == slash_byte then
      next_is_upper = true
      r[#r + 1] = dot_byte
    else
      r[#r + 1] = byte
    end
  end

  if r[1] == nil then return '', 'elixir defmodule snippet: `r` table is empty' end
  if r[1] >= 97 and r[1] <= 122 then r[1] = r[1] - 32 end

  return string.char(unpack(r))
end

local function defmodule_snippet()
  local module_name, error = pathToPascalCase(vim.fn.expand('%:r'))
  if error then
    vim.notify(error, vim.log.levels.ERROR)
    return fmt('Arquivo ganhou o filetype elixir após sua criação, precisa recarregar os snippets', i(1))
  end
  module_name = string.gsub(module_name, '^%.*', '')

  -- Use the module name as a node so we can
  -- select it cycling the nodes
  -- local str = string.format('defmodule {} do\n\t{}\nend')
  -- return fmt(str, { i(2, module_name), i(1) })

  -- Don't make the module name a node
  local str = string.format('defmodule %s do\n\t{}\nend', module_name)
  return fmt(str, i(1))
end

local function pre_format_inspect_snippet()
  return fmt('{}<pre>{}\n\t<%= inspect({}, pretty: true) %>\n{}</pre>{}', { i(5), i(3), i(1, '@form'), i(4), i(2) })
end

luasnip.add_snippets('elixir', {
  s('hx', fmt('~H"""\n{}\n"""', i(1))),
  s('mod', defmodule_snippet()),
  s('pre', pre_format_inspect_snippet()),
  s('insp', pre_format_inspect_snippet()),
})
