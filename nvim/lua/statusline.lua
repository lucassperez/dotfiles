--[[
Maybe one day I can also think about the taline (winbar):
https://github.com/MariaSolOs/dotfiles/blob/f1d6229f4a4675745aff95c540dc8f1b9007a77a/.config/nvim/lua/winbar.lua
]]

--[[
I used this as a guide:
https://github.com/MariaSolOs/dotfiles/blob/f1d6229f4a4675745aff95c540dc8f1b9007a77a/.config/nvim/lua/statusline.lua

But this reddit post has other examples:
https://www.reddit.com/r/neovim/comments/17hbep3/anyone_built_a_statusline_with_no_plugins/
https://github.com/VonHeikemen/nvim-starter/blob/xx-user-plugins/lua/user/statusline.lua
]]

local M = {}

local colors = {
  bg1 = '#323d43',
  bg2 = '#505a60',
  bg3 = '#3c474d',
  fg = '#d8caac',
  aqua = '#87c095',
  green = '#a7c080',
  orange = '#e39b7b',
  purple = '#d39bb6',
  red = '#e68183',
  -- grey1 = '#868d80',
  -- grey2 = '#bbc2cf',
  preto = '#000000',
  branco = '#ffffff',
  offwhite = '#bbc2cf',
  git = {
    added = '#00af00',
    modified = '#c39f00',
    removed = '#ec2929',
  },
}

local mode = {
  highlight_group = 'StatusLine_My_Mode_Normal',
  name = 'NORMAL',
  mapping = {
    ['n'] = 'NORMAL',
    ['no'] = 'O-PENDING',
    ['nov'] = 'O-PENDING',
    ['noV'] = 'O-PENDING',
    ['no\22'] = 'O-PENDING',
    ['niI'] = 'NORMAL',
    ['niR'] = 'NORMAL',
    ['niV'] = 'NORMAL',
    ['nt'] = 'NORMAL',
    ['ntT'] = 'NORMAL',
    ['v'] = 'VISUAL',
    ['vs'] = 'VISUAL',
    ['V'] = 'V-LINE',
    ['Vs'] = 'V-LINE',
    ['\22'] = 'V-BLCK',
    ['\22s'] = 'V-BLCK',
    ['s'] = 'SELECT',
    ['S'] = 'S-LINE',
    ['\19'] = 'S-BLCK',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    ['ix'] = 'INSERT',
    ['R'] = 'REPLCE',
    ['Rc'] = 'REPLCE',
    ['Rx'] = 'REPLCE',
    ['Rv'] = 'V-REPLCE',
    ['Rvc'] = 'V-REPLCE',
    ['Rvx'] = 'V-REPLCE',
    ['c'] = 'COMMND',
    ['cv'] = 'EX',
    ['ce'] = 'EX',
    ['r'] = 'REPLCE',
    ['rm'] = 'MORE',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
  },
}

--[[
This function dynamically changes the value
of the mode.highlight_group depending on the
current vim mode (normal, insert, visual etc)
]]
local function set_mode_highlight_group()
  local current_mode = vim.api.nvim_get_mode().mode

  mode.name = mode.mapping[current_mode] or current_mode
  local m = mode.name

  if m == 'NORMAL' then
    mode.highlight_group = 'StatusLine_My_Mode_Normal'
  elseif m == 'COMMND' or mode.name == 'EX' then
    mode.highlight_group = 'StatusLine_My_Mode_Command'
  elseif m == 'INSERT' then
    mode.highlight_group = 'StatusLine_My_Mode_Insert'
  elseif m == 'VISUAL' or m:find('^V%-') then
    mode.highlight_group = 'StatusLine_My_Mode_Visual'
  elseif m == 'REPLCE' then
    mode.highlight_group = 'StatusLine_My_Mode_Replace'
  elseif m == 'TERMINAL' then
    mode.highlight_group = 'StatusLine_My_Mode_Terminal'
  elseif m == 'SELECT' or m:find('^S%-') then
    mode.highlight_group = 'StatusLine_My_Mode_Select'
  else
    mode.highlight_group = 'StatusLine_My_Mode_Fallback'
  end
end

function M.mode()
  return ' ' .. mode.name .. ' '
end

--[[
The git_diff function resets the color at the end using the %* special combination.
This is because it uses different colors for added, modified and removed, and I
wanted to avoid coloring what comes afterwards as those colors.
We could make every component end with %* to clear and start with its own color,
but I decided to put the colors at the render function.
]]
function M.git_diff(minimal)
  -- OBS: In neovim 0.11.0, get_hunks works a little different
  -- and sometimes show more hunks than there really are.
  -- )=
  local h = require('gitsigns').get_hunks()
  if not h or #h == 0 then return '' end

  local diff_str = ''
  local t = vim.b['gitsigns_status_dict']

  if t.added and t.added > 0 then
    --
    diff_str = string.format('%s%%#StatusLine_My_GitDiff_Added#+%s ', diff_str, t.added)
  end

  if t.changed and t.changed > 0 then
    --
    diff_str = string.format('%s%%#StatusLine_My_GitDiff_Modified#~%s ', diff_str, t.changed)
  end

  if t.removed and t.removed > 0 then
    --
    diff_str = string.format('%s%%#StatusLine_My_GitDiff_Removed#-%s ', diff_str, t.removed)
  end

  diff_str = diff_str:gsub('%s*$', '')

  if minimal then
    -- return string.format('%s%%* (%s)', diff_str, #h)
    return string.format('h: %s %s%%*', #h, diff_str)
  end

  return 'hunks: ' .. #h .. ' diff: ' .. diff_str .. '%*'
end

function M.lsp_clients_names()
  if vim.bo.filetype == '' then return '' end

  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })

  if #buf_clients == 0 then return '' end

  local s = ''
  for _, client in pairs(buf_clients) do
    s = client.name .. ', ' .. s
  end

  s = s:gsub(', $', '')

  return s
end

function M.diagnostic(minimal)
  local diagnostics_amount = #(vim.diagnostic.get(0))

  if diagnostics_amount == 0 then return '' end

  if minimal then
    return 'd: '.. diagnostics_amount
  end

  return 'diagnostics: ' .. diagnostics_amount
end

function M.lines()
  return ' %l/%L:%v '
end

function M.filename()
  return ' %f%m%r%h%w '
end

function M.filetype()
  local filetype = vim.bo.filetype
  if filetype == '' then
    return ''
  else
    return ' ' .. vim.bo.filetype .. ' '
  end
end

function M.status_line_color_a()
  -- This uses the mode.highlight_group variable to
  -- dynamically change the color depending on the mode.
  return string.format('%%#%s#', mode.highlight_group)
end

function M.status_line_color_b()
  return '%#StatusLine_My_Filename#'
end

function M.status_line_color_c()
  return '%#StatusLine#'
end

function M.render()
  -- This makes it dynamic, if I change to global or not global
  -- during a vim session, the status line will get redrawn accordingly.
  -- This literally will never happen, but anyways.
  local is_global = vim.o.laststatus == 3
  -- Change the colors of the statusline of non focused windows when
  -- not using a global status line.
  if not is_global and vim.api.nvim_get_current_win() ~= tonumber(vim.g.statusline_winid or 0) then
    return ' ' .. M.filename() .. '%=' .. M.filetype() .. M.lines()
  end

  set_mode_highlight_group()

  local minimal = true

  return table.concat({
    M.status_line_color_a(),
    M.mode(),
    M.status_line_color_b(),
    M.filename(),
    M.status_line_color_c(),
    '%=',
    M.diagnostic(minimal),
    ' ',
    M.git_diff(minimal),
    -- Git diff removes the colors at the end to avoid coloring everything
    -- afterwards as, for example, green. So we set the color again.
    M.status_line_color_c(),
    ' ',
    M.lsp_clients_names(),
    ' ',
    M.status_line_color_b(),
    M.filetype(),
    M.status_line_color_a(),
    M.lines(),
  })
end

--- Colors
vim.cmd(string.format('hi StatusLine guifg=%s guibg=%s gui=none', colors.fg, colors.bg3))

vim.cmd(string.format('hi StatusLine_My_Filename guifg=%s guibg=%s gui=none', colors.fg, colors.bg2))

vim.cmd(string.format('hi StatusLine_My_GitDiff_Added    guifg=%s guibg=%s', colors.git.added, colors.bg3))
vim.cmd(string.format('hi StatusLine_My_GitDiff_Modified guifg=%s guibg=%s', colors.git.modified, colors.bg3))
vim.cmd(string.format('hi StatusLine_My_GitDiff_Removed  guifg=%s guibg=%s', colors.git.removed, colors.bg3))

vim.cmd(string.format('hi StatusLine_My_Mode_Normal   guifg=%s guibg=%s gui=bold', colors.bg1, colors.green))
vim.cmd(string.format('hi StatusLine_My_Mode_Command  guifg=%s guibg=%s gui=bold', colors.bg1, colors.purple))
vim.cmd(string.format('hi StatusLine_My_Mode_Insert   guifg=%s guibg=%s gui=bold', colors.bg1, colors.fg))
vim.cmd(string.format('hi StatusLine_My_Mode_Visual   guifg=%s guibg=%s gui=bold', colors.bg1, colors.red))
vim.cmd(string.format('hi StatusLine_My_Mode_Replace  guifg=%s guibg=%s gui=bold', colors.bg1, colors.orange))
vim.cmd(string.format('hi StatusLine_My_Mode_Terminal guifg=%s guibg=%s gui=bold', colors.bg1, colors.aqua))
vim.cmd(string.format('hi StatusLine_My_Mode_Select   guifg=%s guibg=%s gui=bold', colors.red, colors.bg1))
vim.cmd(string.format('hi StatusLine_My_Mode_Fallback guifg=%s guibg=%s gui=bold', colors.branco, colors.preto))
----------

--- Options
-- This just makes sense when not using
-- a global status line.
local inactive_white = true
if inactive_white then
  vim.cmd(string.format('hi StatusLineNC guifg=%s guibg=%s gui=none', colors.preto, colors.offwhite))
else
  vim.cmd('hi clear StatusLineNC')
  vim.cmd('hi link StatusLineNC StatusLine')
end

local global_status_line = true
if global_status_line then
  vim.o.laststatus = 3
else
  vim.o.laststatus = 2
end
----------

vim.o.statusline = "%!v:lua.require('statusline').render()"

return M
