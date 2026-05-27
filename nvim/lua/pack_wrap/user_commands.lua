local complete = require('utils.user_command_complete')

local function list_resolved_and_disabled(resolved, disabled)
  local k = {}
  for _, value in ipairs(resolved) do
    table.insert(k, value.name)
  end
  for _, value in ipairs(disabled) do
    table.insert(k, value.name)
  end
  return k
end

local function complete_resolved_and_disabled(resolved, disabled)
  return complete.simple(list_resolved_and_disabled(resolved, disabled))
end

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

  vim.keymap.set('n', 'q', '<CMD>bw!<CR>', { buffer = buf, nowait = true, silent = true, })

  return buf
end

return {
  create = function(pack_wrap_loaded, resolved, disabled)
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
      complete = complete.with_subcommands(
        { 'list', 'update', 'delete' },
        list_resolved_and_disabled(resolved, disabled)
      ),
    })

    vim.api.nvim_create_user_command('PackList', function(opts)
      local buf = open_pack_list_window({ "Loading..." }, opts.bang)

      vim.schedule(function()
        local filters = {
          any = #opts.fargs > 0,
          disabled = {},
          enabled = {},
        }

        if filters.any then
          for _, f in ipairs(opts.fargs) do
            -- Not very optmized, but oh, well
            local found = false
            for _, p in ipairs(disabled) do
              if p.name == f then
                found = true
                break
              end
            end
            if found then
              filters.disabled[#filters.disabled + 1] = f
            else
              filters.enabled[#filters.enabled + 1] = f
            end
          end
        end

        local packs

        if filters.any then
          if #filters.enabled > 0 then
            packs = vim.pack.get(filters.enabled)
          elseif #filters.disabled > 0 then
            packs = {}
          else
            -- This means invalid input, I'll let vim.pack.get error out
            packs = vim.pack.get(opts.fargs)
          end
        else
          packs = vim.pack.get()
        end

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

        local should_show_disabled
        if not filters.any and #disabled > 0 then
          should_show_disabled = true
        elseif #filters.disabled > 0 then
          should_show_disabled = true
        else
          should_show_disabled = false
        end

        if should_show_disabled then
          if #packs > 0 then
            table.insert(lines, '  ----------------------------------------------------------------------')
          end

          local disabled_names_to_show = {}

          if #filters.disabled > 0 then
            disabled_names_to_show = filters.disabled
          else
            for _, p in ipairs(disabled) do
              disabled_names_to_show[#disabled_names_to_show + 1] = p.name
            end
          end

          for i, plugin_name in ipairs(disabled_names_to_show) do
            table.insert(lines, string.format(
              '      %03s  %-30s -- disabled --',
              i + #packs,
              plugin_name
            ))
          end
        end

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
      end)

    end, {
      nargs = '*',
      complete = complete_resolved_and_disabled(resolved, disabled),
      bang = true,
    })

    vim.api.nvim_create_user_command('PackUpdate', function(opts)
      if #opts.fargs > 0 then
        vim.pack.update(opts.fargs, { force = opts.bang })
      else
        vim.pack.update(nil, { force = opts.bang })
      end
    end, {
      nargs = '*',
      bang = true,
      complete = complete_resolved_and_disabled(resolved, disabled),
    })

    vim.api.nvim_create_user_command('PackDelete', function(opts)
      vim.pack.del(opts.fargs, { force = opts.bang })
    end, {
      nargs = '+',
      bang = true,
      complete = complete_resolved_and_disabled(resolved, disabled),
    })
  end
}
