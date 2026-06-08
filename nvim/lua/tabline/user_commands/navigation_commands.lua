return function(state)
  local function goto_buffer(direction)
    if #state.buffers == 0 then
      return
    end

    local new_i = state.current_i + direction
    local new_bufnr

    if new_i > #state.buffers then
      new_i = 1
    elseif new_i < 1 then
      new_i = #state.buffers
    end

    new_bufnr = state.buffers[new_i].bufnr

    if vim.api.nvim_buf_is_valid(new_bufnr) then
      -- Setting current buffer already triggers a redraw,
      -- so no need to call vim.cmd.redrawtabline()
      vim.api.nvim_set_current_buf(new_bufnr)
      state.current_i = new_i
      state.current_bufnr = new_bufnr
    end
  end

  local function move_current_buffer(direction)
    if #state.buffers == 0 then
      return
    end

    local new_i = state.current_i + direction

    if new_i > #state.buffers then
      new_i = 1
    elseif new_i < 1 then
      new_i = #state.buffers
    end

    local tmp = state.buffers[state.current_i]
    state.buffers[state.current_i] = state.buffers[new_i]
    state.buffers[new_i] = tmp
    vim.cmd.redrawtabline()
  end

  local function goto_buffer_by_i(i)
    if type(i) == 'string' then
      if (i):match('^[Ff][Ii][Rr][Ss][Tt]$') then
        i = -1
      elseif (i):match('^[Ll][Aa][Ss][Tt]$') then
        i = 0
      else
        i = tonumber(i)
      end
    else
      i = tonumber(i)
    end

    if not i then
      vim.notify('Invalid buffer index: ' .. vim.inspect(i), vim.log.levels.ERROR)
      return
    end

    local buf
    if i == 0 or i > #state.buffers then
      i = #state.buffers
    elseif i < 0 then
      i = 1
    end

    buf = state.buffers[i]

    if not buf then
      vim.notify('Could not find buf somehow', vim.log.levels.ERROR)
      return
    end

    state.current_i = i
    state.current_bufnr = buf.bufnr
    vim.api.nvim_set_current_buf(buf.bufnr)
  end

  vim.api.nvim_create_user_command('BPrevious', function () goto_buffer(-1) end, {})
  vim.api.nvim_create_user_command('BNext', function () goto_buffer(1) end, {})

  vim.api.nvim_create_user_command('BMovePrevious', function () move_current_buffer(-1) end, {})
  vim.api.nvim_create_user_command('BMoveNext', function () move_current_buffer(1) end, {})

  local command_buf_options = {
    nargs = 1,
    complete = function()
      local items = { 'first', 'last' }
      local i = 3
      while i <= #state.buffers + 2 do
        items[i] = tostring(i - 2)
        i = i + 1
      end
      return items
    end
  }

  vim.api.nvim_create_user_command('B', function(cmd_args)
    goto_buffer_by_i(cmd_args.args)
  end, command_buf_options)

  vim.api.nvim_create_user_command('Buffer', function(cmd_args)
    goto_buffer_by_i(cmd_args.args)
  end, command_buf_options)
end
