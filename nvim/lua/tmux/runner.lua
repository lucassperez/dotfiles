local attached_pane = nil

local function call_if(callback)
  if type(callback) == 'function' then callback() end
end

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

-- Attach_pane is async because of possible vim.ui.input.
-- So we pass a callback to it to be executed after vim.ui.input returns.
local function attach_pane(callback)
  if not vim.env.TMUX then
    vim.notify('Não há uma sessão de tmux rodando', vim.log.levels.ERROR)
    return
  end

  local panes = list_panes()

  if #panes <= 1 then
    vim.notify('Não há painéis o suficiente', vim.log.levels.ERROR)
    call_if(callback)
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
        call_if(callback)
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
        call_if(callback)
        return
      end

      for _, p in ipairs(panes) do
        if p.index == input then
          if p.id == current.id then
            vim.notify('Não é possível anexar o painel atual', vim.log.levels.ERROR)
            call_if(callback)
            return
          end

          attached_pane = p
          vim.cmd.echohl('String')
          vim.cmd.echo(string.format([['Painel fixado: %s']], input))
          vim.cmd.echohl('None')

          call_if(callback)
          return
        end
      end

      vim.notify('Painel não encontrado', vim.log.levels.ERROR)
    end)
  end)
end

local function ensure_attached(callback)
  if not attached_pane then
    attach_pane(callback)
    return
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
    call_if(callback)
    return
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
  --   attach_pane(callback)
  --   return
  -- end
  -- call_if(callback)

  attached_pane = nil
  attach_pane(callback)
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
    return attached_pane
  end,
  clear_attached_pane = function()
    local old = attached_pane
    attached_pane = nil
    return old
  end,
}
