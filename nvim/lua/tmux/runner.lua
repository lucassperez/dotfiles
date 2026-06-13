local attached_pane = nil

local unallowed_list = {}

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

local function pane_current_program(pane)
  if pane == nil or pane.id == nil then
    return nil
  end

  return vim.fn.systemlist(
    string.format('tmux display-message -t %s -p "#{pane_current_command}"', pane.id)
  )[1]
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

local function ensure_target_not_in_unallowed_list()
  local current_prog = pane_current_program(attached_pane)

  if vim.tbl_contains(unallowed_list, current_prog) then
    vim.notify(
      -- We assume attached-pane is not nil because of the ensure_attached
      ---@diagnostic disable-next-line: need-check-nil
      string.format('Painel %s rodando programa na lista ignorada: %s', attached_pane.id, current_prog),
      vim.log.levels.WARN
    )
    return false
  end

  return true
end

local function send_tmux_keys(str, opts)
  if not vim.env.TMUX then
    vim.notify('Não há uma sessão de tmux rodando', vim.log.levels.ERROR)
    return
  end

  if not str or str == '' then
    return
  end

  opts = opts or {}

  if opts.clear == nil then
    opts.clear = true
  end

  if opts.force_send == nil then
    opts.force_send = false
  end

  local clear_before_send = opts.clear

  coroutine.wrap(function()
    while true do
      if not ensure_attached() then
        return
      end

      if opts.force_send then
        break
      end

      if ensure_target_not_in_unallowed_list() then
        break
      end

      attached_pane = nil
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
