-- When gitsigns is not available, I want to use the
-- builtin lualine 'diff' component, so I return a
-- plain string with the value 'diff', so it uses
-- the builtin 'diff' component.
if not pcall(require, 'gitsigns') then return 'diff' end

-- Otherwise, I use a gitsigns_status_dict to build it.
-- The reason for that is that the builtin only updates
-- when we save the file, whereas the gitsigns one updates
-- as we change the file, even before saving.

local verbose = true

--[[
Whatever comes after this gets the colors from diff.
I could add a `.. '%#lualine_c_command#'` at the end
to "reset" the colors, but then it gets reset to lualine_c.
If this was set to lualine_a, b, y or z, it would reset to the wrong color.
Because of this, I'm setting the "color" reset at the init file.
Not cool, but I'm not sure of a better way.
]]

local function verboseFunc()
  local h = require('gitsigns').get_hunks()
  if #h == 0 then return '' end

  local diff_str = ''
  local t = vim.b['gitsigns_status_dict']
  if t.added and t.added > 0 then diff_str = diff_str .. '%#lualine_x_diff_added_command#+' .. t.added .. ' ' end
  if t.changed and t.changed > 0 then
    diff_str = diff_str .. '%#lualine_x_diff_modified_command#~' .. t.changed .. ' '
  end
  if t.removed and t.removed > 0 then
    diff_str = diff_str .. '%#lualine_x_diff_removed_command#-' .. t.removed .. ' '
  end
  diff_str = diff_str:gsub(' $', '')

  return 'hunks: ' .. #h .. ' diff: ' .. diff_str
end

local function simplerFunc()
  local h = require('gitsigns').get_hunks()
  if #h == 0 then return '' end

  local diff_str = ''
  local t = vim.b['gitsigns_status_dict']
  if t.added and t.added > 0 then diff_str = diff_str .. '%#lualine_x_diff_added_command#+' .. t.added .. ' ' end
  if t.changed and t.changed > 0 then
    diff_str = diff_str .. '%#lualine_x_diff_modified_command#~' .. t.changed .. ' '
  end
  if t.removed and t.removed > 0 then
    diff_str = diff_str .. '%#lualine_x_diff_removed_command#-' .. t.removed .. ' '
  end
  diff_str = diff_str:gsub(' $', '')

  return #h .. ': ' .. diff_str
end

return verbose and verboseFunc or simplerFunc
