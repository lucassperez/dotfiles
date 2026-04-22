local state = {
  error_count = 0,
  log_path = vim.fn.stdpath('config') .. '/nvim-require.log'
}

local function try_require(path)
  local ok, result = pcall(require, path)

  if ok then
    return result
  end

  state.error_count = state.error_count + 1

  -- Only print this the first time a pcall returned an error
  if state.error_count == 1 then
    vim.notify('ERROR!', vim.log.levels.ERROR)
  end

  vim.notify('Could not require the path `' .. path .. '`', vim.log.levels.ERROR)

  -- Print only first line of the error
  -- vim.notify('  ' .. string.sub(result, 1, string.find(result, '\n')), vim.log.levels.ERROR)

  -- Get first 7 lines
  local tbl_lines = vim.split(result, '\n')
  local str_lines = table.concat(vim.list_slice(tbl_lines, 1, 7), '\n')
  vim.notify(str_lines, vim.log.levels.ERROR)

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
  if state.error_count > 0 then
    vim.notify('---', vim.log.levels.WARN)
    vim.notify('Check file ' .. state.log_path .. ' for more information', vim.log.levels.WARN)
  end
end

return {
  try_require = try_require,
  report_errors = report_errors,
}
