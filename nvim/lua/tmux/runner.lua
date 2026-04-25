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
 return { index = result[1], id = result[2], }
end

local function is_valid_pane(pane)
  if not pane then return false end

  for _, p in ipairs(list_panes()) do
    if p.id == pane.id then
      return true
    end
  end

  return false
end

local function attach_pane(callback)
  if not vim.env.TMUX then
    vim.notify('Não há uma sessão de tmux rodando', vim.log.levels.ERROR)
    return
  end

  local panes = list_panes()

  if #panes <= 1 then
    vim.notify('Não há painéis o suficiente', vim.log.levels.ERROR)
    if type(callback) == 'function' then callback(false) end
    return
  end

  local current = current_pane()

  if #panes == 2 then
    for _, p in ipairs(panes) do
      if p.id ~= current.id then
        attached_pane = p
        vim.cmd.echohl('String')
        vim.cmd.echo(string.format([['Painel fixado: %s']], p.index))
        vim.cmd.echohl('None')
        if type(callback) == 'function' then callback(true) end
        return
      end
    end
  end

  vim.cmd.echohl('String')
  vim.fn.jobstart({ 'tmux', 'display-panes' }, { detach = true })
  vim.schedule(function()
    vim.ui.input({ prompt = 'Painel tmux nº: ' }, function(input)
      vim.cmd.echohl('None')
      if not input then
        if type(callback) == 'function' then callback(false) end
        return
      end

      for _, p in ipairs(panes) do
        if p.index == input then
          if p.id == current.id then
            vim.notify('Não é possível anexar o painel atual', vim.log.levels.ERROR)
            if type(callback) == 'function' then callback(false) end
            return
          end

          attached_pane = p
          vim.cmd.echohl('String')
          vim.cmd.echo(string.format([['Painel fixado: %s']], input))
          vim.cmd.echohl('None')

          if type(callback) == 'function' then callback(true) end
          return
        end
      end

      vim.notify('Painel não encontrado', vim.log.levels.ERROR)
      -- if type(callback) == 'function' then callback(false) end
    end)
  end)
end

local function ensure_attached(callback)
  if not attached_pane then
    attach_pane(callback)
    return
  end

  if not is_valid_pane(attached_pane) then
    attached_pane = nil
    attach_pane(callback)
    return
  end

  if type(callback) == 'function' then callback(true) end
end

local function send_tmux_keys(str, clear_before_send)
  if not vim.env.TMUX then
    vim.notify('Não há uma sessão de tmux rodando', vim.log.levels.ERROR)
    return
  end

  if not str or str == '' then return end

  if clear_before_send == nil then
    clear_before_send = true
  end

  ensure_attached(function()
    if attached_pane == nil then
      vim.notify('Não há painel fixado', vim.log.levels.ERROR)
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

    vim.fn.jobstart(vim.list_extend({
      'tmux', 'send-keys', '-t', attached_pane.id
    }, parts), { detach = true })
  end)
end

return {
  attach_pane = attach_pane,
  send_tmux_keys = send_tmux_keys,
  get_attached_pane = function()
    print(vim.inspect(attached_pane))
    return attached_pane
  end,
}
