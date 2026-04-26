--[[
Eu ia chamar de Pack Wrapper,
mas PackWrap soa mt bem kkj
]]

local function blank_state()
  return {
    loaded = {},
    resolved = {},
    seen = {},
    visiting = {},
  }
end

local state

local function nil_if_empty_table(table)
  if type(table) ~= 'table' then
    return table
  end

  if #table > 0 then
    return table
  end

  for _ in pairs(table) do
    return table
  end

  return nil
end

local function is_lazy(plugin)
  if not plugin.data then
    return false
  end

  if plugin.data.filetype or plugin.data.event then
    return true
  end

  return false
end

local function load_plugin(plugin)
  if plugin.data.disable then
    vim.notify('Tried loading disabled plugin: ' .. vim.inspect(plugin), vim.log.levels.WARN)
    vim.notify('Skipping', vim.log.levels.WARN)
    return
  end

  if state.loaded[plugin.name] then
    return
  end

  for _, dep in ipairs(plugin.data.dependencies or {}) do
    load_plugin(dep)
  end

  state.loaded[plugin.name] = true

  if plugin.data.before then plugin.data.before() end

  local ok, result = pcall(vim.cmd.packadd, plugin.name)
  if not ok then
    vim.notify('Something wrong happened when packadd-ing ' .. plugin.name, vim.log.WARN)
    vim.notify(result, vim.log.WARN)
  end

  if plugin.data.after then plugin.data.after() end
end

local function assume_github_if_not_specified(src)
  if src == nil then
    return nil
  end

  if string.match(src, '^https?://') or string.match(src, '^git@') then
    return src
  end

  return 'https://github.com/' .. src
end

local function normalized_hook(plugin)
  if not plugin.hook then return nil end

  if type(plugin.hook) == 'function' then
    -- If hook is a function itself,
    -- assume install and update kinds
    return {
      kind = { 'install', 'update' },
      callback = plugin.hook,
    }
  end

  local kind = plugin.hook.kind
  local callback = plugin.hook.callback

  if type(callback) == 'string' then
    callback = function()
      vim.cmd(plugin.hook.callback)
    end
  end

  if type(callback) ~= 'function' then
    vim.notify('pack_wrap#normalized_hook: Plugin must provide a function as hook callback: ' .. plugin.name, vim.log.levels.ERROR)
    vim.notify('pack_wrap#normalized_hook: Skipping', vim.log.levels.ERROR)
    return nil
  end

  if kind == nil then
    kind = { 'install', 'update' }
  elseif type(kind) == 'string' then
    kind = { kind }
  end

  return {
    kind = kind,
    callback = callback,
  }
end

-- Receives a user spec and translates to vim.pack format
local function normalized(user_spec)
  local src

  if user_spec[1] and type(user_spec[1]) ~= 'string' then
    error(
      string.format(
        'pack_wrap#normalized: Plugin com primeiro argumento posicoinal do tipo errado (deveria ser string): %s (%s)',
        vim.inspect(user_spec[1]),
        vim.inspect(user_spec)
      )
    )
  end

  if user_spec[2] and type(user_spec[2]) ~= 'function' then
    error(
      string.format(
        'pack_wrap#normalized: Plugin com segundo argumento posicoinal do tipo errado (deveria ser função): %s (%s)',
        vim.inspect(user_spec[2]),
        vim.inspect(user_spec)
      )
    )
  end

  if type(user_spec) == 'string' then
    src = user_spec
  else
    src = user_spec.src or user_spec[1]
  end

  src = assume_github_if_not_specified(src)

  if not src then
    error('pack_wrap#normalized: Plugin spec não possui src: ' .. vim.inspect(user_spec))
  end

  local name = user_spec.name or string.match(src, '[^/]+$')

  if not name or name == '' then
    error('pack_wrap#normalized: Plugin spec não possui name: ' .. vim.inspect(user_spec))
  end

  local version = user_spec.version
  local after = user_spec.after or user_spec[2]
  local before = user_spec.before

  -- local dependencies = vim.deepcopy(user_spec.dependencies) or {}
  local dependencies = {}
  if user_spec.dependencies then
    for _, dep in ipairs(user_spec.dependencies) do
      table.insert(dependencies, normalized(dep))
    end
  end

  local hook = normalized_hook(user_spec)
  local filetype = user_spec.filetype
  local event = user_spec.event

  if type(filetype) == 'string' then
    filetype = { filetype }
  end

  return {
    name = name,
    src = src,
    version = version,
    data = {
      -- even if data is empty, I'm leaving it in so we don't have to
      -- nil check everytime we try to access a field inside data.
      -- Eg: if plugin.data.after then ... end would have to be if plugin.data and plugin.data.after then ... end
      -- That would be too annoying.
      disable = user_spec.disable,
      dependencies = nil_if_empty_table(dependencies),
      before = before,
      after = after,
      hook = nil_if_empty_table(hook),
      filetype = nil_if_empty_table(filetype),
      event = event,
    }
  }
end

local function resolve(plugin)
  if plugin.data.disable then
    return
  end

  if state.seen[plugin.name] then
    vim.notify(string.format(
      'pack_wrap#resolve: Plugins com o mesmo nome detectados: %s', plugin.name),
      vim.log.levels.WARN
    )
    vim.notify('Ignorando ocorrências posteriores e usando a primeira configuração que apareceu.', vim.log.levels.WARN)
    return
  end

  if state.visiting[plugin.name] then
    error('pack_wrap#resolve: Dependência cíclica detectada: ' .. plugin.name)
  end

  state.visiting[plugin.name] = true
  state.seen[plugin.name] = true

  if plugin.data.dependencies then
    for _, dep in ipairs(plugin.data.dependencies) do
      resolve(dep)
    end
  end

  state.visiting[plugin.name] = nil

  table.insert(state.resolved, plugin)
end

local function register_hooks_auto_commands()
  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('PackWrapChanged', { clear = true }),
    callback = function(ev)
      local plugin = ev.data.spec

      if plugin.data == nil or plugin.data.hook == nil then
        return
      end

      local event_kind = ev.data.kind

      local matches = false
      for _, k in ipairs(plugin.data.hook.kind) do
        if k == event_kind then
          matches = true
          break
        end
      end

      if not matches then
        return
      end

      if not ev.data.active then
        -- There is a chance hook does not even need
        -- the plugin loaded, but I kept it since I don't
        -- have many hooks anyways.
        -- But one example is stylua's hook, that just
        -- calls a cargo install.
        load_plugin(plugin)
      end

      if plugin.data.hook.callback then
        plugin.data.hook.callback(ev)
      end
    end
  })
end

local function register_filetype_autocmds(ft_plugins, group)
  for _, plugin in ipairs(ft_plugins) do
    -- TODO think about registering one autocmd per filetype instead
    -- of one autocmd per plugin?
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = plugin.data.filetype,
      -- once = true,
      callback = function()
        load_plugin(plugin)
      end
    })
  end
end

local function register_event_autocmds(event_plugins, group)
  for _, plugin in ipairs(event_plugins) do
    vim.api.nvim_create_autocmd(plugin.data.event, {
      group = group,
      once = true,
      callback = function()
        load_plugin(plugin)
      end
    })
  end
end

local function execute()
  local eager = {}
  -- Lazy
  local ft_plugins = {}
  local event_plugins = {}
  local any_lazy = false

  for _, plugin in ipairs(state.resolved) do
    if is_lazy(plugin) then
      any_lazy = true

      if plugin.data.filetype then
        table.insert(ft_plugins, plugin)
      end
      if plugin.data.event then
        table.insert(event_plugins, plugin)
      end
    else
      table.insert(eager, plugin)
    end
  end

  register_hooks_auto_commands()

  if any_lazy then
    local group = vim.api.nvim_create_augroup('PackWrapLazy', { clear = true })

    register_filetype_autocmds(ft_plugins, group)
    register_event_autocmds(event_plugins, group)
  end

  vim.pack.add(state.resolved, { load = false })

  for _, plugin in ipairs(eager) do
    load_plugin(plugin)
  end

  return state
end

local function call(list)
  state = blank_state()
  for _, user_spec in ipairs(list) do
    local pack_spec = normalized(user_spec)
    resolve(pack_spec)
  end
  execute()
  require('pack_wrap.user_commands').create(state.loaded)
end

return {
  call = call,
}
