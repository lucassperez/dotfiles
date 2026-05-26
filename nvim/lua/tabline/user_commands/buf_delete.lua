return function(state)
  local function find_replacement(bufnr)
    for i, buf in ipairs(state.buffers) do
      if buf.bufnr == bufnr then
        if i < #state.buffers then
          return state.buffers[i + 1].bufnr
        elseif i > 1 then
          return state.buffers[i - 1].bufnr
        end
        return nil
      end
    end
    return nil
  end

  local function close(bufnr, force, vim_cmd)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    if not force and vim.bo[bufnr].modified then
      vim.notify('No write since last change (add ! to override)', vim.log.levels.ERROR)
      return
    end

    local replacement = nil

    state.pending_delete[bufnr] = true

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        replacement = replacement or find_replacement(bufnr)

        if replacement then
          vim.api.nvim_win_set_buf(win, replacement)
        else
          replacement = vim.api.nvim_create_buf(true, false)
          vim.api.nvim_win_set_buf(win, replacement)
        end
      end
    end

    local ok, err = pcall(vim.api.nvim_cmd, { cmd = vim_cmd, args = { bufnr }, bang = force }, {})
    state.pending_delete[bufnr] = nil

    if not ok then
      vim.notify(vim_cmd .. ': ' .. vim.inspect(err), vim.log.levels.ERROR)
    end
  end

  local function resolve_bufnr(cmd_name, fargs)
    if #fargs > 0 then
      local arg = fargs[1]
      local n = tonumber(arg)
      if n then
        return n
      end
      local bufnr = vim.fn.bufnr(arg)
      if bufnr == -1 then
        vim.notify(cmd_name .. ': No matching buffer for ' .. arg, vim.log.levels.ERROR)
        return nil
      end
      return bufnr
    end
    return vim.api.nvim_get_current_buf()
  end

  local cmd_opts = {
    bang = true,
    nargs = '?',
    complete = 'buffer',
  }

  vim.api.nvim_create_user_command('BDelete', function(opts)
    local bufnr = resolve_bufnr('BDelete', opts.fargs)
    if bufnr then close(bufnr, opts.bang, 'bdelete') end
  end, vim.tbl_extend('force', cmd_opts, { desc = 'Deleta um buffer enquanto preserva o layout das janelas' }))

  vim.api.nvim_create_user_command('BWipeout', function(opts)
    local bufnr = resolve_bufnr('BWipeout', opts.fargs)
    if bufnr then close(bufnr, opts.bang, 'bwipeout') end
  end, vim.tbl_extend('force', cmd_opts, { desc = 'Wipeout um buffer enquanto preserva o layout das janelas' }))
end
