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
    return {
      kind = { 'install', 'update' },
      callback = plugin.hook,
    }
  end

  if type(plugin.hook.callback) == 'string' then
    plugin.hook.callback = function()
      vim.cmd(plugin.hook.callback)
    end
  end

  if type(plugin.hook.callback) ~= 'function' then
    vim.notify('pack_wrap#normalized_hook: Plugin must provide a function as hook callback: ' .. plugin.name, vim.log.levels.ERROR)
    vim.notify('pack_wrap#normalized_hook: Skipping', vim.log.levels.ERROR)
    return nil
  end

  local h = {
    kind = nil,
    callback = plugin.callback
  }

  if plugin.kind == nil then
    h.kind = { 'install', 'update' }
  elseif type(plugin.kind) == 'string' then
    h.kind = { plugin.kind }
  end

  return h
end

local function normalized(plugin)
  local src

  if type(plugin) == 'string' then
    src = plugin
  else
    src = plugin.src or plugin[1]
  end

  src = assume_github_if_not_specified(src)

  if not src then
    error('pack_wrap#normalize: Plugin spec não possui src: ' .. vim.inspect(plugin))
  end

  local name = plugin.name or string.match(src, '[^/]+$')

  if not name or name == '' then
    error('pack_wrap#normalize: Plugin spec não possui name: ' .. vim.inspect(plugin))
  end

  local version = plugin.version
  local after = plugin.after or plugin[2]
  local before = plugin.before
  local dependencies = vim.deepcopy(plugin.dependencies) or {}
  local hook = normalized_hook(plugin)
  local filetype = plugin.filetype

  if type(filetype) == 'string' then
    filetype = { filetype }
  end

  return {
    name = name,
    src = src,
    version = version,
    dependencies = dependencies,
    before = before,
    after = after,
    hook = hook,
    filetype = filetype
  }
end

local function make_resolved(plugin)
  return {
    name = plugin.name,
    src = plugin.src,
    version = plugin.version,
    data = {
      before = plugin.before,
      after = plugin.after,
      hook = plugin.hook,
      filetype = plugin.filetype,
    }
  }
end

local function resolve(plugin)
  if plugin.disable then
    return
  end

  local normalized_plugin = normalized(plugin)

  if state.seen[normalized_plugin.name] then
    error(string.format('pack_wrap#resolve: Plugin\'s com o mesmo nome detectados: %s', normalized_plugin.name))
  end

  if state.visiting[normalized_plugin.name] then
    error('pack_wrap#resolve: Dependência cíclica detectada: ' .. normalized_plugin.name)
  end

  state.visiting[normalized_plugin.name] = true
  state.seen[normalized_plugin.name] = true

  for _, dep in ipairs(normalized_plugin.dependencies) do
    -- TODO Decide what to do when parent has filetype, but child does not
    resolve(dep)
  end

  state.visiting[normalized_plugin.name] = nil

  table.insert(state.resolved, make_resolved(normalized_plugin))
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
        vim.cmd.packadd(plugin.name)
      end

      if plugin.data.hook.callback then
        plugin.data.hook.callback(ev)
      end
    end
  })
end

local function register_filetype_autocmds(ft_plugins)
  for _, plugin in ipairs(ft_plugins) do
    -- TODO think about registering one autocmd per filetype instead
    -- of one autocmd per plugin?
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('PackWrapFt', { clear = true }),
      pattern = plugin.data.filetype,
      -- once = true,
      callback = function()
        if state.loaded[plugin.name] then
          return
        end

        state.loaded[plugin.name] = true

        if plugin.data.before then plugin.data.before() end
        vim.cmd.packadd(plugin.name)
        if plugin.data.after then plugin.data.after() end
      end
    })
  end
end

local function execute()
  local before = {}
  local after = {}
  local ft_plugins = {}
  local eager = {}

  for _, plugin in ipairs(state.resolved) do
    if plugin.data.filetype then
      table.insert(ft_plugins, plugin)
    else
      table.insert(eager, plugin)

      if plugin.data.before then
        table.insert(before, plugin.data.before)
      end
      if plugin.data.after then
        table.insert(after, plugin.data.after)
      end
    end
  end

  register_hooks_auto_commands()
  register_filetype_autocmds(ft_plugins)

  for _, callback in ipairs(before) do
    callback()
  end

  vim.pack.add(state.resolved, { load = false })

  for _, plugin in ipairs(eager) do
    state.loaded[plugin.name] = true
  end

  for _, callback in ipairs(after) do
    callback()
  end

  return state
end

local function call(list)
  state = blank_state()
  for _, plugin in ipairs(list) do
    resolve(plugin)
  end
  execute()
  require('pack_wrap.user_commands').create(state.loaded)
end

return {
  call = call,
}
