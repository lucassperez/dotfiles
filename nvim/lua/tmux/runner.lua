local attached_pane = nil

local function list_panes()
  local result = vim.fn.systemlist('tmux list-panes -F "#{pane_index}:#{pane_id}"')
  local panes = {}

  for _, line in ipairs(result) do
    local index, id = line:match('^(%d+):(.+)$')
    if index and id then
      panes[#panes + 1] = { index = index, id = id }
    end
  end

  return panes
end

local function current_pane()
  local result = vim.fn.systemlist('tmux display-message -p "#{pane_index}\n#{pane_id}"')
  return { index = result[1], id = result[2] }
end

local function attach_pane()
  if not vim.env.TMUX then
    vim.notify('Não há uma sessão de tmux rodando', vim.log.levels.ERROR)
    return false
  end

  local panes = list_panes()

  if #panes <= 1 then
    vim.notify('Não há painéis o suficiente', vim.log.levels.ERROR)
    return false
  end

  local current = current_pane()

  if #panes == 2 then
    for _, p in ipairs(panes) do
      if p.id ~= current.id then
        attached_pane = p
        vim.cmd.echohl('String')
        vim.cmd.echo(string.format([['Painel fixado: %s']], p.index))
        vim.cmd.echohl('None')
        break
      end
    end
    return true
  end

  local co = coroutine.running()

  vim.cmd.echohl('String')
  vim.fn.jobstart({ 'tmux', 'display-panes' }, { detach = true })
  vim.schedule(function()
    vim.ui.input({ prompt = 'Painel tmux nº: ' }, function(input)
      vim.cmd.echohl('None')

      if not input or input == '' then
        -- Oh, no! A goto!
        -- Since every exit point has to call coroutine.resume(co), I thought
        -- that a good way to "early return but also resume" was with a goto.
        goto done
      end

      do
        local found = false
        for _, p in ipairs(panes) do
          if p.index == input then
            found = true

            if p.id == current.id then
              vim.notify('Não é possível anexar o painel atual', vim.log.levels.ERROR)
            else
              attached_pane = p
              vim.cmd.echohl('String')
              vim.cmd.echo(string.format([['Painel fixado: %s']], input))
              vim.cmd.echohl('None')
            end

            break
          end
        end

        if not found then
          vim.notify('Painel não encontrado', vim.log.levels.ERROR)
        end
      end

      ::done::
      -- Unblocks whatever was yielded
      coroutine.resume(co)
    end)
  end)

  -- Blocking call
  coroutine.yield()

  return attached_pane ~= nil
end

local function ensure_attached()
  if not attached_pane then
    return attach_pane()
  end

  local all_panes = list_panes()

  local is_current_valid = false
  for _, p in ipairs(all_panes) do
    if p.id == attached_pane.id then
      is_current_valid = true
      break
    end
  end

  if is_current_valid then
    return true
  end

  -- If attached pane doesn't exist anymore but you
  -- want to try and auto attach to another pane that
  -- has the same index, use the commented code below.
  -- local candidate
  -- for _, p in ipairs(all_panes) do
  --   if p.index == attached_pane.index then
  --     candidate = p
  --     break
  --   end
  -- end
  -- if candidate and candidate.id ~= current_pane().id then
  --   attached_pane = candidate
  -- else
  --   attached_pane = nil
  --   attach_pane()
  -- end

  attached_pane = nil
  return attach_pane()
end

local function send_tmux_keys(str, clear_before_send)
  if not vim.env.TMUX then
    vim.notify('Não há uma sessão de tmux rodando', vim.log.levels.ERROR)
    return
  end

  if not str or str == '' then
    return
  end

  if clear_before_send == nil then
    clear_before_send = true
  end

  coroutine.wrap(function()
    if not ensure_attached() then
      return
    end

    local parts = {}

    if clear_before_send then
      table.insert(parts, 'C-l')
    end

    table.insert(parts, str)

    local last_is_ctrl = string.match(parts[#parts], '^C%-.+$')

    if not last_is_ctrl then
      table.insert(parts, 'C-m')
    end

    if attached_pane == nil then
      -- Paranoia check after ensure_attached had already returned true lol
      vim.notify('Não há painel fixado', vim.log.levels.ERROR)
      return
    end

    vim.fn.jobstart(vim.list_extend({
      'tmux', 'send-keys', '-t', attached_pane.id
    }, parts), { detach = true })
  end)()
end

return {
  attach_pane = function() coroutine.wrap(attach_pane)() end,
  send_tmux_keys = send_tmux_keys,
  get_attached_pane = function()
    return attached_pane
  end,
  clear_attached_pane = function()
    local old = attached_pane
    attached_pane = nil
    return old
  end,
}
