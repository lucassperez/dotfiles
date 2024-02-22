local use_telescope = false

local selection = {
  use_telescope = use_telescope,
  use_fzf_lua = not use_telescope,
}

if not selection.use_telescope and not selection.use_fzf_lua then
  -- If both are false, defaulting to fzf now
  selection.use_fzf_lua = true
end

local t

if selection.use_fzf_lua then
  t = require('plugins.FUZZY_FINDER.fzf-lua')
elseif selection.use_telescope then
  t = require('plugins.FUZZY_FINDER.telescope')
end

return t
