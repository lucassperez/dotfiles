local function simple(list)
  return function(_, cmd_line, cursor_pos)
    local before_cursor = cmd_line:sub(1, cursor_pos):gsub('^%s*', '')
    -- If we type :MyCmd <subcmd> <option><Space> (a literal trailing space),
    -- and press enter, then the args (splitted list) will have an
    -- empty string as the last argument. Which is great, because
    -- we define "current" as the last item of the split.
    -- But it keeps leading spaces as well. So that is why we gsubbed
    -- leading whitespaces above when defining before_cursor.
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

local function with_subcommands(subcommands, items)
  return function(_, cmd_line, cursor_pos)
    local before_cursor = cmd_line:sub(1, cursor_pos):gsub('^%s*', '')
    local args = vim.split(before_cursor, '%s+', { trimempty = false })
    local current = args[#args] or ''

    if #args <= 2 then
      local matches = {}
      for _, sub in ipairs(subcommands) do
        if sub:find('^' .. vim.pesc(current)) then
          table.insert(matches, sub)
        end
      end
      return matches
    end

    if not vim.tbl_contains(subcommands, args[2]) then
      return {}
    end

    local selected = {}
    for i = 3, #args - 1 do
      selected[args[i]] = true
    end

    local matches = {}

    for _, item in ipairs(items) do
      if not selected[item] and item:find('^' .. vim.pesc(current)) then
        table.insert(matches, item)
      end
    end

    return matches
  end
end

return {
  simple = simple,
  with_subcommands = with_subcommands,
}
