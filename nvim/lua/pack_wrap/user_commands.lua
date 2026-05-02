local function complete_resolved(resolved)
  return function()
    local k = {}
    for _, value in pairs(resolved) do
      table.insert(k, value.name)
    end
    return k
  end
end

local function open_pack_list_window(lines, floating)
  -- TODO reuse other packwrap buffer instead of creating a new one
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

  vim.keymap.set('n', 'q', '<CMD>bw!<CR>', { buffer = buf, nowait = true, silent = true, })

  return buf
end

local cached_packs = nil

local function get_packs(filter)
  filter = filter or {}
  if #filter > 0 then
    return vim.pack.get(filter)
  end

  if not cached_packs then
    cached_packs = vim.pack.get()
  end

  return cached_packs
end

return {
  create = function(pack_wrap_loaded, resolved)
    vim.api.nvim_create_user_command('Pack', function(opts)
      local cmd = opts.fargs[1] or 'list'
      local args = {}
      for i = 2, #opts.fargs do
        table.insert(args, opts.fargs[i])
      end

      if cmd == 'list' then
        cmd = 'PackList'
      elseif cmd == 'update' then
        cmd = 'PackUpdate'
      elseif cmd == 'delete' then
        cmd = 'PackDelete'
      else
        vim.notify('Invalid command: ' .. cmd, vim.log.levels.ERROR)
        return
      end

      vim.api.nvim_cmd({
        cmd = cmd,
        bang = opts.bang,
        args = args
      }, {})
    end, {
      nargs = '*',
      bang = true,
      complete = function(_, cmd_line, cursor_pos)
        local before_cursor = cmd_line:sub(1, cursor_pos)
        local args = vim.split(before_cursor, '%s+')

        if #args <= 2 then
          return { 'list', 'update', 'delete' }
        end

        return complete_resolved(resolved)()
      end
    })

    vim.api.nvim_create_user_command('PackList', function(opts)
      local buf = open_pack_list_window({ "Loading..." }, opts.bang)

      vim.schedule(function()
        local packs = get_packs(opts.fargs)

        local lines = {}

        table.insert(lines, '   AL  nº  name                             rev    branches   (version)')
        table.insert(lines, '  ----------------------------------------------------------------------')

        for i, pack in ipairs(packs) do
          local format_str = "   %s %03s  %-30s [%s] %-10s"

          if pack.spec.version then
            format_str = format_str .. ' (%s)'
          end

          local active = pack.active
          local is_loaded = pack_wrap_loaded[pack.spec.name]

          local active_loaded_str
          if active and is_loaded then
            active_loaded_str = ' L'
          elseif active then
            active_loaded_str = 'A '
          else
            active_loaded_str = '  '
          end

          local line = string.format(
            format_str,
            active_loaded_str,
            i,
            pack.spec.name,
            string.sub(pack.rev, 1, 6),
            pack.branches and pack.branches[1],
            pack.spec.version
          ):gsub('%s+$', '')

          table.insert(lines, line)
        end

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
      end)

    end, {
      nargs = '*',
      complete = complete_resolved(resolved),
      bang = true,
    })

    vim.api.nvim_create_user_command('PackUpdate', function(opts)
      if #opts.fargs > 0 then
        vim.pack.update(opts.fargs, { force = opts.bang })
      else
        vim.pack.update({ force = opts.bang })
      end
    end, {
      nargs = '*',
      bang = true,
      complete = complete_resolved(resolved),
    })

    vim.api.nvim_create_user_command('PackDelete', function(opts)
      vim.pack.del(opts.fargs, { force = opts.bang })
    end, {
      nargs = '+',
      bang = true,
      complete = complete_resolved(resolved),
    })
  end
}
