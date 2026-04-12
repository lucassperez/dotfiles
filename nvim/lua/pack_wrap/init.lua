--[[
Eu ia chamar de Pack Wrapper,
mas PackWrap soa mt bem kkj

PackWrap funciona com 2 fases, Preparação e Execução.

Preparação:
- Normaliza os specs para o formato do vim.pack
- Recursivamente faz o flat quando um plugin adiciona a chave dependencies
- Separa em before/after

Execução:
- Cria os autocommands para os hooks
- Execute os callbacks before
- vim.pack.add() todos os plugins
- Executa os callbacks after
]]

local function blank_state()
  return {
    resolved = {},
    seen = {},
    visiting = {},
    buckets = {
      plugins = {},
      -- O before é para plugins com init
      before = {},
      -- O config é para plugins com config
      after = {},
      hooks = {},
    },
  }
end

local state = blank_state()

local function normalize_hook(plugin)
  local hook_type = type(plugin.hook)

  if hook_type == 'function' then
    plugin.hook = {
      kinds = { 'install', 'update' },
      callback = plugin.hook,
    }
  elseif hook_type == 'table' then
    if plugin.hook.kinds == nil then
      plugin.hook.kinds = { 'install', 'update' }
    elseif type(plugin.hook.kinds) == 'string' then
      plugin.hook.kinds = { plugin.hook.kinds }
    end
  end
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

local function normalize(plugin)
  if type(plugin) == 'string' then
    plugin = { src = plugin }
  end

  if plugin[1] then
    if plugin.src == nil and type(plugin[1]) == 'string' then
      plugin.src = plugin[1]
    end
    plugin[1] = nil
  end

  plugin.src = assume_github_if_not_specified(plugin.src)

  if not plugin.src then
    error('pack_wrap#normalize: Plugin spec não possui src: ' .. vim.inspect(plugin))
  end

  if plugin[2] then
    if type(plugin[2]) == 'function' then
      if plugin.after == nil then
        plugin.after = plugin[2]
      end
    else
      error('pack_wrap#normalize: O segundo item posicional deve ser uma função: ' .. vim.inspect(plugin))
    end
    plugin[2] = nil
  end

  if plugin.name == nil then
    plugin.name = string.match(plugin.src, '[^/]+$')
  end

  if not plugin.name or plugin.name == '' then
    error('pack_wrap#normalize: Plugin spec não possui name: ' .. vim.inspect(plugin))
  end

  if plugin.dependencies == nil then
    plugin.dependencies = {}
  end

  if plugin.hook then
    normalize_hook(plugin)
  end

  return plugin
end

local function resolve(plugin)
  plugin = normalize(plugin)

  if state.seen[plugin.src] then
    return
  end

  if state.visiting[plugin.src] then
    error('pack_wrap#resolve: Dependência cíclica detectada: ' .. plugin.name)
  end

  state.visiting[plugin.src] = true
  state.seen[plugin.src] = true

  for _, dep in ipairs(plugin.dependencies) do
    resolve(dep)
  end

  state.visiting[plugin.src] = nil

  table.insert(state.resolved, plugin)
end

local function bucketize()
  for _, plugin in ipairs(state.resolved) do
    local pack_spec = {
      src = plugin.src,
      name = plugin.name,
      version = plugin.version
    }

    table.insert(state.buckets.plugins, pack_spec)

    if plugin.before then
      table.insert(state.buckets.before, plugin.before)
    end

    if plugin.after then
      table.insert(state.buckets.after, plugin.after)
    end

    if plugin.hook then
      table.insert(state.buckets.hooks, {
        plugin = pack_spec,
        hook = plugin.hook,
      })
    end
  end
end

local function register_hooks_auto_commands()
  for _, item in ipairs(state.buckets.hooks) do
    vim.api.nvim_create_autocmd('PackChanged', {
      once = true,
      callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind

        if name ~= item.plugin.name then
          return
        end

        local matches
        for _, k in ipairs(item.hook.kinds) do
          if k == kind then
            matches = true
            break
          end
        end

        if not matches then
          return
        end

        if not ev.data.active then
          vim.cmd.packadd(item.plugin.name)
        end

        if item.hook.callback then
          item.hook.callback(ev)
        end
      end
    })
  end
end

local function prepare(list)
  state = blank_state()

  for _, plugin in ipairs(list) do
    resolve(plugin)
  end

  bucketize()
end

local function execute()
  register_hooks_auto_commands()

  for _, callback in ipairs(state.buckets.before) do
    callback()
  end

  vim.pack.add(state.buckets.plugins)

  for _, callback in ipairs(state.buckets.after) do
    callback()
  end
end

return {
  prepare = prepare,
  execute = execute,
  create_user_commands = require('pack_wrap.user_commands'),
}
