-- state.tab_str, state.tab_len
local function update_state_tabs(state)
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr('$')
  state.tab_str = string.format(' %s/%s ', current_tab, total_tabs)
  state.tab_len = vim.fn.strdisplaywidth(state.tab_str)
end

local function build_buf_obj(bufnr, visible, current_bufnr, no_name)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    path = no_name
  end

  local buf = {
    bufnr = bufnr,
    path = path,
    modified = vim.bo[bufnr].modified,
    readonly = vim.bo[bufnr].readonly,
    non_modifiable = not vim.bo[bufnr].modifiable,
    visibility = 0,
  }

  if bufnr == current_bufnr then
    buf.visibility = 2
  elseif visible[bufnr] then
    buf.visibility = 1
    -- else
    --   buf.visibility = 0
  end
  return buf
end

local function update_state_buffers(state, opts)
  local visible = {}

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local b = vim.api.nvim_win_get_buf(win)
    visible[b] = true
  end

  local listed = {}
  for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted then
      listed[bufnr] = true
    end
  end

  local new_buffers = {}
  for _, buf in ipairs(state.buffers) do
    if listed[buf.bufnr] then
      -- Será que precisa recalcular o buf inteiro?
      -- Acho que sim, né, ele pode ter sido minimizado etc
      local fresh_buf = build_buf_obj(buf.bufnr, visible, state.current_bufnr, opts.no_name)
      table.insert(new_buffers, fresh_buf)
      listed[buf.bufnr] = nil
    end
  end

  for bufnr in pairs(listed) do
    local fresh_buf = build_buf_obj(bufnr, visible, state.current_bufnr, opts.no_name)
    table.insert(new_buffers, fresh_buf)
  end

  state.buffers = new_buffers

  local found = false

  for i, buf in ipairs(state.buffers) do
    if buf.bufnr == state.current_bufnr then
      state.current_i = i
      found = true
      break
    end
  end

  if not found then
    if #state.buffers > 0 then
      state.current_i = 1
      state.current_bufnr = state.buffers[1].bufnr
    else
      state.current_i = 0
      state.current_bufnr = 0
    end
  end
end

local function calculate_buf_tree_cache_key(buffers)
  local parts = {}
  for i, buf in ipairs(buffers) do
    parts[i] = string.format('%s:%s', buf.bufnr, buf.path)
  end

  return table.concat(parts, '|')
end

return {
  update_state = function(state, opts)
    state.current_bufnr = vim.api.nvim_get_current_buf()
    update_state_tabs(state)
    update_state_buffers(state, opts)

    local key = calculate_buf_tree_cache_key(state.buffers)
    if key ~= state.buf_tree_cache_key then
      state.buf_tree_flattened = require('tabline.buf_tree').calculate_paths(state.buffers, opts.directory_separator)
      state.buf_tree_cache_key = key
    end

    return state
  end
}
