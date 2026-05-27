return function(list)
  return function(_, cmd_line, cursor_pos)
    local before_cursor = cmd_line:sub(1, cursor_pos):gsub('^%s*', '')
    local args = vim.split(before_cursor, '%s+', { trimempty = false })
    local current = args[#args] or ''

    local matches = {}

    for _, item in ipairs(list) do
      if item:find('^' .. vim.pesc(current)) then
        table.insert(matches, item)
      end
    end

    return matches
  end
end
