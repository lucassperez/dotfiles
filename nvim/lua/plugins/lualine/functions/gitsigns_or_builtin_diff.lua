-- When gitsigns is not available, I want to use the
-- builtin lualine 'diff' component, so I return a
-- plain string with the value 'diff', so it uses
-- the builtin 'diff' component.
if not pcall(require, 'gitsigns') then return 'diff' end

-- Otherwise, I use a gitsigns_status_dict to build it.
-- The reason for that is that the builtin only updates
-- when we save the file, whereas the gitsigns one updates
-- as we change the file, even before saving.
return function ()
  local t = vim.b['gitsigns_status_dict']
  local s = ''
  if t.added and t.added > 0 then
    s = s .. '%#lualine_x_diff_added_command#+' .. t.added .. ' '
  end
  if t.changed and t.changed > 0 then
    s = s .. '%#lualine_x_diff_modified_command#~' .. t.changed .. ' '
  end
  if t.removed and t.removed > 0 then
    s = s .. '%#lualine_x_diff_removed_command#-' .. t.removed .. ' '
  end

  return s:gsub(' $', '')
end
