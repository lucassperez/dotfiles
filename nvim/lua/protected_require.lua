local state = {
  log_path = vim.fn.stdpath('config') .. '/nvim-require.log',
  errors = {},
}

local function try_require(path)
  local ok, result = pcall(require, path)

  if ok then
    return result
  end

  table.insert(state.errors, 'Could not require the path `' .. path .. '`')

  -- Get only first line of the error
  -- table.insert(errors, '  ' .. string.sub(result, 1, string.find(result, '\n')))

  -- Get first 7 lines
  local tbl_lines = vim.split(result, '\n')
  local str_lines = table.concat(vim.list_slice(tbl_lines, 1, 7), '\n')
  table.insert(state.errors, str_lines)

  local file = io.open(state.log_path, 'a')
  if file then
    file:write('[' .. os.date('%Y-%m-%d_%H:%M:%S') .. ']: ' .. path .. '\n')
    file:write(result)
    file:write('\n---\n')
    file:close()
  end

  return nil
end

local function report_errors()
  if #state.errors > 0 then
    vim.notify('ERROR!', vim.log.levels.ERROR)
    for _, error in ipairs(state.errors) do
      vim.notify(error, vim.log.levels.ERROR)
    end
    vim.notify('---', vim.log.levels.WARN)
    vim.notify('Check file ' .. state.log_path .. ' for more information', vim.log.levels.WARN)
  end
end

return {
  try_require = try_require,
  report_errors = report_errors,
}
