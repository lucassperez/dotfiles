local complete = require('utils.user_command_complete')

local function list_resolved_and_disabled(resolved, disabled)
  local k = {}
  for _, value in ipairs(resolved) do
    k[#k+1] = value.name
  end
  for _, value in ipairs(disabled) do
    k[#k+1] = value.name
  end
  return k
end

local function complete_resolved_and_disabled(resolved, disabled)
  return complete.simple(list_resolved_and_disabled(resolved, disabled))
end

return {
  create = function(loaded, resolved, disabled)
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
      require('pack_wrap.user_commands.pack_list')(opts, loaded, resolved, disabled)
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
