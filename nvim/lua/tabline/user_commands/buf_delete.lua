return function(state)
  local function recur_find_next(i, direction)
    if i < 1 or i > #state.buffers then
      return nil
    end

    local candidate_bufnr = state.buffers[i].bufnr
    --[[
    With this logic, if for example we have these buffers:
      A, Netrw, B
    If we are at B and call the BDelete command, we will
    land in A, and not in Netrw buffer.
    Same goes for Blame, NvimTree, etc. And any other non buflisted buffer.
    Basically the "special" buffers.
    I didn't mind skipping the unliested buffer, in fact I preferred doing so,
    at list with Netrw/NvimTree, but this is something to think about.
    Maybe unlisted but not floating windows should not be skipped.
    Maybe the options about unlisted buffers could decide this behaviour.
    Maybe a specific option to control what the user wants could be added.
    So one day I could come revisit this.
    ]]
    if vim.api.nvim_buf_is_valid(candidate_bufnr) and vim.bo[candidate_bufnr].buflisted then
      return candidate_bufnr
    end

    return recur_find_next(i + direction, direction)
  end

  local function find_replacement(bufnr)
    for i, buf in ipairs(state.buffers) do
      if buf.bufnr == bufnr then
        return recur_find_next(i + 1, 1) or recur_find_next(i - 1, -1)
      end
    end
    return nil
  end

  local function close(bufnr, force, vim_cmd, cmd_name)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    if not force and vim.bo[bufnr].modified then
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':~:.')
      local choice = vim.fn.confirm(
        string.format('Save changes to "%s"?', filename),
        '&Yes\n&No\n&Cancel',
        1,
        'Question'
      )
      if choice == 1 then
        local ok, err = pcall(vim.api.nvim_buf_call, bufnr, vim.cmd.write)
        if not ok then
          vim.notify('tabline: Could not save: ' .. vim.inspect(err), vim.log.levels.ERROR)
          return
        end
      elseif choice == 2 then
        force = true
      else
        return
      end
    end

    state.pending_delete[bufnr] = true

    local replacement = nil
    local ok, err = pcall(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          if not replacement then
            replacement = find_replacement(bufnr) or vim.api.nvim_create_buf(true, false)
          end

          vim.api.nvim_win_set_buf(win, replacement)
        end
      end
    end)

    if not ok then
      vim.notify(
        string.format(
          'tabline#%s (window swap): %s'
          .. "\nProceeding to try and delete/wipe the buffer anyways to honor the user's command",
          cmd_name, vim.inspect(err)
        ),
        vim.log.levels.WARN
      )
    end

    if vim.api.nvim_buf_is_valid(bufnr) then
      ok, err = pcall(vim.api.nvim_cmd, { cmd = vim_cmd, args = { bufnr }, bang = force }, {})

      if not ok then
        vim.notify('tabline#' .. cmd_name .. ': ' .. vim.inspect(err), vim.log.levels.ERROR)
      end
    end

    state.pending_delete[bufnr] = nil
  end

  local function calculate_list_of_bufnrs(opts)
    local bufnrs = {}

    if opts.range > 0 then
      for bufnr = opts.line1, opts.line2 do
        bufnrs[#bufnrs + 1] = bufnr
      end
    end

    for _, arg in ipairs(opts.fargs) do
      local bufnr = tonumber(arg) or vim.fn.bufnr(arg)
      if bufnr == -1 then
        vim.notify(opts.name .. ': No matching buffer for ' .. arg, vim.log.levels.ERROR)
        return {}
      end

      bufnrs[#bufnrs + 1] = bufnr
    end

    if #bufnrs == 0 then
      return { vim.api.nvim_get_current_buf() }
    end

    local seen = {}
    local unique = {}

    for _, bufnr in ipairs(bufnrs) do
      if not seen[bufnr] then
        seen[bufnr] = true
        unique[#unique + 1] = bufnr
      end
    end

    return unique
  end

  local cmd_opts = {
    bang = true,
    bar = true,
    nargs = '*',
    range = true,
    addr = 'buffers',
    complete = 'buffer',
  }

  vim.api.nvim_create_user_command('BDelete', function(opts)
    for _, bufnr in ipairs(calculate_list_of_bufnrs(opts)) do
      close(bufnr, opts.bang, 'bdelete', opts.name)
    end
  end, vim.tbl_extend('force', cmd_opts, { desc = 'Deleta um buffer enquanto preserva o layout das janelas' }))

  vim.api.nvim_create_user_command('BWipeout', function(opts)
    for _, bufnr in ipairs(calculate_list_of_bufnrs(opts)) do
      close(bufnr, opts.bang, 'bwipeout', opts.name)
    end
  end, vim.tbl_extend('force', cmd_opts, { desc = 'Wipeout um buffer enquanto preserva o layout das janelas' }))
end
