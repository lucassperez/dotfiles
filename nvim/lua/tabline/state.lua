local function should_include(bufnr, visible_any_tab, visible_non_float, unlisted_opts)
  if vim.fn.isdirectory(vim.api.nvim_buf_get_name(bufnr)) == 1 then
    return false
  end

  if vim.bo[bufnr].buflisted then
    return true
  end

  local whitelist = unlisted_opts.whitelist_ft_names or {}

  if not whitelist[vim.bo[bufnr].filetype] then
    return false
  end

  if unlisted_opts.show_normal and visible_non_float[bufnr] then
    return true
  end

  if unlisted_opts.show_floating and visible_any_tab[bufnr] and not visible_non_float[bufnr] then
    return true
  end

  return false
end

local function update_state_tabs(state)
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr('$')
  state.tab_str = string.format(' %s/%s ', current_tab, total_tabs)
  state.tab_len = vim.fn.strdisplaywidth(state.tab_str)
end

local function build_buf_obj(bufnr, visible_current_tab, current_bufnr, opts)
  local ft = vim.bo[bufnr].filetype
  local path = vim.api.nvim_buf_get_name(bufnr)

  if not vim.bo[bufnr].buflisted then
    local whitelist = (opts.unlisted_buffers or {}).whitelist_ft_names or {}
    if whitelist[ft] == true then
      -- If ft is in whitelist but without a name,
      -- we capitalize the first character and wraps in braces [].
      path = '[' .. ft:sub(1, 1):upper() .. ft:sub(2) .. ']'
    else
      path = whitelist[ft]
    end
  elseif path == '' then
    path = opts.no_name
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
  elseif visible_current_tab[bufnr] then
    buf.visibility = 1
  end

  return buf
end

local function update_state_buffers(state, opts)
  local visible_current_tab = {}

  -- Here we list only buffers visible in current tab to get highlights right.
  -- A buffer open in another tab should not get the visible highlight.
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    visible_current_tab[vim.api.nvim_win_get_buf(win)] = true
  end

  ----------------------
  ----------------------
  ----------------------

  local visible_any_tab = {}
  local visible_non_float = {}

  -- But here we list visible windows that could go to the tabline with the
  -- intention of including special (unlisted) buffers, like Netrw, Fzf, Help pages etc.
  -- The special buffers have to be included in opts.unlisted_buffers.whitelist_ft_names.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    visible_any_tab[b] = true
    if vim.api.nvim_win_get_config(win).relative == '' then
      visible_non_float[b] = true
    end
  end

  ----------------------
  ----------------------
  ----------------------

  local included = {}
  local new_buffers = {}

  for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
    if should_include(bufnr, visible_any_tab, visible_non_float, opts.unlisted_buffers) then
      included[bufnr] = true
    end
  end

  --[[
    Next loop gets the buffers that already existed (were in state.buffers) and
    put in new_buffers list, and the loop that comes afterwards gets the buffers
    that are new and put at the end of new_buffers.
    This way, new_buffers will keep the old order, and put new guys at the end.
    It does this by manipulating the included list.
    At first, included has everyone in a possible random order. The order managed
    by nvim is not neccessarily the order we want, specially if we have
    reordered buffers.
    So we first iterate the buffers that were present before (state.buffers).
    If it is still to be presented (not removed), we put in new_buffers and
    delete it from included!
    Now on second pass, we iterate over every buffer (vim.api.nvim_list_bufs())
    and if it still is in included, it means it is a new buffer, because it did
    not get deleted. So it goes to the end of the new_buffers.
  ]]

  for _, buf in ipairs(state.buffers) do
    if included[buf.bufnr] then
      local fresh_buf = build_buf_obj(buf.bufnr, visible_current_tab, state.current_bufnr, opts)
      table.insert(new_buffers, fresh_buf)
      included[buf.bufnr] = nil
    end
  end

  -- At this stage, included only has newly opened buffers.
  -- Theoretically, if there is more than one newly opened buffer, iterating
  -- it with pairs gives random order. So we should iterate over all buffers
  -- again with vim.api.nvim_list_bufs, using the order nvim gives them since
  -- that is the best we can do. Like this:
  --         for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  -- But usually there would be only one (or zero) buffers left inside included,
  -- so I don't care having random order on the rare ocasion I open two or more
  -- buffers at the same time. A random order is just as good than the order
  -- assigned by neovim anyways, since it will also be random from the user's
  -- perspective. A random for a random is just as random.
  for bufnr in pairs(included) do
    if included[bufnr] then
      local fresh_buf = build_buf_obj(bufnr, visible_current_tab, state.current_bufnr, opts)
      table.insert(new_buffers, fresh_buf)
    end
  end

  state.buffers = new_buffers

  ----------------------
  ----------------------
  ----------------------

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
