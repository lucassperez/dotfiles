local selection = {
  use_telescope = false,
  use_fzf_lua = true,
  default = 'fzf-lua',
}

local t
local ok

if selection.use_fzf_lua then
  ok, t = pcall(require, 'plugins.FUZZY_FINDER.fzf-lua')
elseif selection.use_telescope then
  ok, t = pcall(require, 'plugins.FUZZY_FINDER.telescope')
end

if not ok then
  P('vamos de default', t)
  ok, t = pcall(require, 'plugins.FUZZY_FINDER.' .. selection.default)
end

if not ok then
  P('ERRO NO FUZZY FINDER: ', selection, t)
  return ok, t
end

return t
