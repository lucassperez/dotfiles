local function find_packwrap_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match('^packwrap://list') then
        return buf
      end
    end
  end
end

local function jump_to_buf(buf)
  local wins = vim.fn.win_findbuf(buf)

  if #wins > 0 then
    vim.api.nvim_set_current_win(wins[1])
    return true
  end

  return false
end

local function open_pack_list_window(lines, floating)
  local existing_buf = find_packwrap_buf()

  if existing_buf then
    if not jump_to_buf(existing_buf) then
      vim.cmd.tabnew()
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, existing_buf)
    end

    vim.bo[existing_buf].modifiable = true
    vim.api.nvim_buf_set_lines(existing_buf, 0, -1, false, lines)
    vim.bo[existing_buf].modifiable = false

    return existing_buf
  end

  local buf = vim.api.nvim_create_buf(true, true)
  local ok = pcall(vim.api.nvim_buf_set_name, buf, 'packwrap://list')
  if not ok then
    vim.api.nvim_buf_set_name(buf, 'packwrap://list:' .. buf)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'packwrap'
  vim.bo[buf].modifiable = false

  local win
  local tab

  if floating then
    local height = math.floor(vim.o.lines * 0.9)
    local width = math.floor(vim.o.columns * 0.9)

    win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2) - 1,
      col = math.floor((vim.o.columns - width) / 2),
      border = 'rounded'
    })
  else
    local bufname = vim.api.nvim_buf_get_name(buf)
    vim.cmd.tabnew(bufname)
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    tab = vim.api.nvim_get_current_tabpage()
  end

  vim.api.nvim_create_autocmd('BufWinLeave', {
    buffer = buf,
    callback = function()
      vim.schedule(function()
        local wins = vim.fn.win_findbuf(buf)
        if #wins == 0 then
          if tab and vim.api.nvim_tabpage_is_valid(tab) then
            vim.cmd('tabclose ' .. vim.api.nvim_tabpage_get_number(tab))
          end
        end
      end)
    end,
  })

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false

  vim.keymap.set('n', 'q', '<cmd>bw!<CR>', { buffer = buf, nowait = true, silent = true })

  return buf
end

-- No filters: bulk get all on-disk, walk spec for plugins not found on disk.
-- Returns five lists:
--   cat1: Installed - enabled + on disk     ([]vim.pack objects)
--   cat2: Missing   - enabled + not on disk ([]packwrap objects)
--   cat3: Orphan    - on disk, not in spec  ([]vim.pack objects)
--   cat4: Disabled  - on disk               ([]vim.pack objects)
--   cat5: Disabled  - not on disk           ([]packwrap objects)
local function get_all_categorized(resolved, disabled)
  local resolved_set = {}
  for _, r in ipairs(resolved) do
    resolved_set[r.name] = true
  end

  local disabled_set = {}
  for _, p in ipairs(disabled) do
    disabled_set[p.name] = true
  end

  local on_disk = vim.pack.get()
  local seen = {}

  local cat1 = {} -- installed
  local cat3 = {} -- orphan
  local cat4 = {} -- disabled on disk

  for _, pack in ipairs(on_disk) do
    local name = pack.spec.name
    seen[name] = true

    if resolved_set[name] then
      cat1[#cat1 + 1] = pack
    elseif disabled_set[name] then
      cat4[#cat4 + 1] = pack
    else
      cat3[#cat3 + 1] = pack
    end
  end

  local cat2 = {} -- missing
  for _, r in ipairs(resolved) do
    if not seen[r.name] then
      cat2[#cat2 + 1] = r
    end
  end

  local cat5 = {} -- disabled
  for _, p in ipairs(disabled) do
    if not seen[p.name] then
      cat5[#cat5 + 1] = p
    end
  end

  return cat1, cat2, cat3, cat4, cat5
end

-- Bulk get enabled plugin names, peeling off missing ones one at a time using
-- the error message (one missing name kills the whole call).
local function get_enabled_filtered(names)
  local remaining = names
  local cat1 = {} -- installed
  local cat2 = {} -- missing

  while #remaining > 0 do
    local ok, result = pcall(vim.pack.get, remaining)

    if ok then
      for _, pack in ipairs(result) do
        cat1[#cat1 + 1] = pack
      end

      break
    end

    local missing = result:match('Plugin `(.-)` is not installed')
    if not missing then
      vim.notify('pack_wrap#list: ' .. result, vim.log.levels.ERROR)
      break
    end

    cat2[#cat2 + 1] = missing

    local next_remaining = {}
    for _, name in ipairs(remaining) do
      if name ~= missing then
        next_remaining[#next_remaining + 1] = name
      end
    end

    remaining = next_remaining
  end

  return cat1, cat2
end

-- With filters: split by spec membership, resolve each group separately.
local function get_filtered_categorized(filters, resolved, disabled)
  local resolved_map = {}
  for _, r in ipairs(resolved) do
    resolved_map[r.name] = r
  end

  local disabled_map = {}
  for _, p in ipairs(disabled) do
    disabled_map[p.name] = p
  end

  local enabled_filters = {}
  local disabled_filters = {}
  -- Unknown filters are arguments passed by the user that are
  -- not in pack wrap buckets (neither resolved nor disabled).
  -- They could be typos or orphanated plugins.
  local unknown_filters = {}

  for _, name in ipairs(filters) do
    if resolved_map[name] then
      enabled_filters[#enabled_filters + 1] = name
    elseif disabled_map[name] then
      disabled_filters[#disabled_filters + 1] = name
    else
      unknown_filters[#unknown_filters + 1] = name
    end
  end

  local cat1, cat2_names = get_enabled_filtered(enabled_filters)

  local cat2 = {} -- missing
  for _, name in ipairs(cat2_names) do
    cat2[#cat2 + 1] = resolved_map[name]
  end

  local cat3 = {} -- orphan
  for _, name in ipairs(unknown_filters) do
    local ok, result = pcall(vim.pack.get, { name })

    if ok then
      -- If ok means that vim.pack.get successfully found the plugin on disk.
      -- This means that that plugin is an orpahn: on disk, but not on packwrap.
      cat3[#cat3 + 1] = result[1]
    else
      -- If not ok, it was a typo or a plugin not present.
      -- Just warn and continue, so we don't fail the whole command because of
      -- one wrong input.
      vim.notify('pack_wrap#list: Plugin not found: ' .. name, vim.log.levels.WARN)
    end
  end

  local cat4 = {} -- disabled on disk (lingering)
  local cat5 = {} -- disabled (and cleaned up, not on disk)
  for _, name in ipairs(disabled_filters) do
    local ok, result = pcall(vim.pack.get, { name })

    if ok then
      cat4[#cat4 + 1] = result[1]
    else
      cat5[#cat5 + 1] = disabled_map[name]
    end
  end

  return cat1, cat2, cat3, cat4, cat5
end

local function format_pack_line(i, pack, loaded)
  local format_str = '   %s %03s  %-30s [%s] %-10s'
  if pack.spec.version then
    format_str = format_str .. ' (%s)'
  end

  local active_loaded_str
  if pack.active and loaded[pack.spec.name] then
    active_loaded_str = ' L'
  elseif pack.active then
    active_loaded_str = 'A '
  else
    active_loaded_str = '  '
  end

  return string.format(
    format_str,
    active_loaded_str,
    i,
    pack.spec.name,
    string.sub(pack.rev, 1, 6),
    pack.branches and pack.branches[1],
    pack.spec.version
  ):gsub('%s+$', '')
end

local function render(buf, cat1, cat2, cat3, cat4, cat5, loaded)
  local lines = {}
  local i = 0

  lines[#lines + 1] = '   AL  nº  name                             rev    branches   (version)'
  lines[#lines + 1] = '  ----------------------------------------------------------------------'

  local sep = lines[#lines]
  local last_drawn_was_a_separator = true

  local function section(items, fmt)
    if #items == 0 then
      return
    end

    if not last_drawn_was_a_separator then
      lines[#lines + 1] = sep
      -- Since we have a guard on #items == 0, it is guaranteed
      -- that we will add at least one item later.
      -- Technically speaking, we should set last_drawn_was_a_separator = true here,
      -- but since we will add at least one item right away, we would set it false
      -- right after. So I just ommited setting it to true, since it was guaranteed
      -- to set it to false just a few lines later.
    end

    for _, item in ipairs(items) do
      i = i + 1
      lines[#lines + 1] = fmt(i, item)
    end

    -- Since we have a guard on #items == 0, it is guaranteed
    -- that we have added at least one item.
    last_drawn_was_a_separator = false
  end

  section(cat1, function(n, pack)
    return format_pack_line(n, pack, loaded)
  end)

  section(cat2, function(n, spec)
    return string.format('       %03s  %-30s %s', n, spec.name, '-- MISSING FROM DISK! --')
  end)

  section(cat3, function(n, pack)
    return string.format('       %03s  %-30s %s', n, pack.spec.name, '-- orphan --')
  end)

  section(cat4, function(n, pack)
    return string.format('       %03s  %-30s %s', n, pack.spec.name, '-- disabled, but on disk! --')
  end)

  section(cat5, function(n, spec)
    return string.format('       %03s  %-30s %s', n, spec.name, '-- disabled --')
  end)

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

return function(opts, loaded, resolved, disabled)
  local buf = open_pack_list_window({ 'Loading...' }, opts.bang)

  vim.schedule(function()
    local cat1, cat2, cat3, cat4, cat5

    if #opts.fargs == 0 then
      cat1, cat2, cat3, cat4, cat5 = get_all_categorized(resolved, disabled)
    else
      cat1, cat2, cat3, cat4, cat5 = get_filtered_categorized(opts.fargs, resolved, disabled)
    end

    render(buf, cat1, cat2, cat3, cat4, cat5, loaded)
  end)
end
