--[[
Maybe one day I can also think about the tabline (winbar):
https://github.com/MariaSolOs/dotfiles/blob/f1d6229f4a4675745aff95c540dc8f1b9007a77a/.config/nvim/lua/winbar.lua
]]

--[[
I used this as a guide:
https://github.com/MariaSolOs/dotfiles/blob/f1d6229f4a4675745aff95c540dc8f1b9007a77a/.config/nvim/lua/statusline.lua

But this reddit post has other examples:
https://www.reddit.com/r/neovim/comments/17hbep3/anyone_built_a_statusline_with_no_plugins/
https://github.com/VonHeikemen/nvim-starter/blob/xx-user-plugins/lua/user/statusline.lua
]]

local opts = {
  -- Still working out rough edges with lsp progress.
  -- Should I show lsps running if they're not attached
  -- to the current buffer? Maybe only while they're not
  -- in progress? I don't know.
  show_lsp_progress = true,

  -- I think that inactive_white can make sense
  -- when not using a global status line.
  inactive_white = true,
  global_status_line = true,

  colors = {
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
      changed = '#c39f00',
      removed = '#ec2929',
    },
  },
  mappings = {
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
  hl = {
    mode = {
      NORMAL   = 'StatusLine_My_Mode_Normal',
      COMMND   = 'StatusLine_My_Mode_Command',
      EX       = 'StatusLine_My_Mode_Command',
      INSERT   = 'StatusLine_My_Mode_Insert',
      VISUAL   = 'StatusLine_My_Mode_Visual',
      REPLCE   = 'StatusLine_My_Mode_Replace',
      TERMINAL = 'StatusLine_My_Mode_Terminal',
      SELECT   = 'StatusLine_My_Mode_Select',
    },
    git = {
      added   = 'StatusLine_My_GitDiff_Added',
      changed = 'StatusLine_My_GitDiff_Changed',
      removed = 'StatusLine_My_GitDiff_Removed',
    }
  },
}

local state = {
  mode = {
    -- highlight_group = opts.hl.mode.NORMAL,
    -- name = 'NORMAL',
  },
  macro = {
    active = false,
    reg = '',
  },
  lsp = {
    collection = {},
    count = 0,
    names = '',
  },
}

local function update_lsp_state()
  if vim.bo.filetype == '' then
    state.lsp.names = ''
    return
  end

  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #buf_clients == 0 then
    state.lsp.names = ''
    return
  end

  if state.lsp.count == 0 then
    state.lsp.names = ''
    return
  end

  local names = {}
  if opts.show_lsp_progress then
    for name, lsp in pairs(state.lsp.collection) do
      if lsp.prog then
        table.insert(names, string.format('%s (%s%%%%)', name, lsp.prog))
      else
        table.insert(names, name)
      end
    end
  else
    for _, client in pairs(buf_clients) do
      table.insert(names, client.name)
    end
  end

  state.lsp.names = table.concat(names, ', ')
end

local function update_macro_state()
  state.macro.reg = vim.fn.reg_recording()
  state.macro.active = state.macro.reg ~= ''
end

local function update_mode_state()
  local current_mode = vim.api.nvim_get_mode().mode
  state.mode.name = opts.mappings[current_mode] or current_mode

  local m = state.mode.name

  if m:match('^V%-') then
    m = 'VISUAL'
  elseif m:match('^S%-') then
    m = 'SELECT'
  end

  state.mode.highlight_group = opts.hl.mode[m] or 'StatusLine_My_Mode_Fallback'
end

local function mode()
  return ' ' .. state.mode.name .. ' '
end

local function diagnostic()
  local diagnostics_amount = #(vim.diagnostic.get(0))

  if diagnostics_amount == 0 then return '' end

  return 'd: '.. diagnostics_amount .. ' '
end

local function git_color_macro_aware(type)
  -- I wish I could not create this
  -- dependency between modules.
  if state.macro.active then
    return state.mode.highlight_group
  end

  return opts.hl.git[type]
end

local function git_hunks()
  -- OBS: In neovim 0.11.0, get_hunks works a little different
  -- and sometimes show more hunks than there really are.
  -- )=

  local h = require('gitsigns').get_hunks(0)

  if not h then
    return ''
  end

  if #h == 0 then
    return ''
  end

  return 'h: ' .. #h .. ' '
end

local function git_diff()
  local t = vim.b['gitsigns_status_dict']

  if not t then
    return ''
  end

  local diffs_t = {}

  -- TODO git component colors itself with macro state.
  -- Onde day I wish it did not have this dependency.

  if t.added and t.added > 0 then
    table.insert(diffs_t, string.format('%%#%s#+%s', git_color_macro_aware('added'), t.added))
  end

  if t.changed and t.changed > 0 then
    table.insert(diffs_t, string.format('%%#%s#~%s', git_color_macro_aware('changed'), t.changed))
  end

  if t.removed and t.removed > 0 then
    table.insert(diffs_t, string.format('%%#%s#-%s', git_color_macro_aware('removed'), t.removed))
  end

  if #diffs_t == 0 then
    return ''
  end

  return table.concat(diffs_t, ' ') .. ' %*'
end

local function lsp_clients_names()
  if state.lsp.names == '' then
    return ''
  end

  return state.lsp.names .. ' '
end

local function lines()
  return ' %l/%L:%v '
end

local function filename()
  return ' %f%m%r%h%w '
end

local function filetype()
  local ft = vim.bo.filetype

  if ft == '' then
    return ''
  end

  return ' ' .. vim.bo.ft .. ' '
end

local function macro_recording()
  if state.macro.active then
    return 'MACRO: ' .. state.macro.reg
  end

  return ''
end

local function status_line_color_a()
  return string.format('%%#%s#', state.mode.highlight_group)
end

local function status_line_color_b()
  return '%#StatusLine_My_Filename#'
end

local function status_line_color_c()
  if state.macro.active then
    return status_line_color_a()
  end
  return '%#StatusLine#'
end

--- Colors
-- StatusLine section A is based on current Mode (StatusLine_My_Mode_*)
-- StatusLine section B is StatusLine_My_Filename group
-- StatusLine section C is StatusLine highlight group, unless macro is recording.
--                      In this case, it is the same as section A

vim.api.nvim_set_hl(0, 'StatusLine', { fg = opts.colors.fg, bg = opts.colors.bg3 })
vim.api.nvim_set_hl(0, 'StatusLine_My_Filename', { fg = opts.colors.fg, bg = opts.colors.bg2 })

vim.api.nvim_set_hl(0, 'StatusLine_My_GitDiff_Added',    { fg = opts.colors.git.added, bg = nil })
vim.api.nvim_set_hl(0, 'StatusLine_My_GitDiff_Changed', { fg = opts.colors.git.changed, bg = nil })
vim.api.nvim_set_hl(0, 'StatusLine_My_GitDiff_Removed',  { fg = opts.colors.git.removed, bg = nil })

vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Normal',   { fg = opts.colors.bg1, bg = opts.colors.green, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Command',  { fg = opts.colors.bg1, bg = opts.colors.purple, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Insert',   { fg = opts.colors.bg1, bg = opts.colors.fg, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Visual',   { fg = opts.colors.bg1, bg = opts.colors.red, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Replace',  { fg = opts.colors.bg1, bg = opts.colors.orange, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Terminal', { fg = opts.colors.bg1, bg = opts.colors.aqua, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Select',   { fg = opts.colors.red, bg = opts.colors.bg1, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine_My_Mode_Fallback', { fg = opts.colors.branco, bg = opts.colors.preto, bold = true })

----------

local function attach_or_detach_func(args, count)
  state.lsp.count = state.lsp.count + count

  if not opts.show_lsp_progress then
    update_lsp_state()
    return
  end

  local lsp_id = args.data.client_id
  local lsp_name = vim.lsp.get_clients({ id = lsp_id })[1].name

  local lsp = state.lsp.collection[lsp_name] or {}

  lsp.id = lsp_id
  lsp.name = lsp_name

  state.lsp.collection[lsp_name] = lsp

  update_lsp_state()
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    attach_or_detach_func(args, 1)
  end
})

vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    attach_or_detach_func(args, -1)
  end
})

if opts.show_lsp_progress then
  -- I already use fidget, but let's play around with this
  vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(args)
      local lsp_id = args.data.client_id
      local lsp_name = vim.lsp.get_clients({ id = lsp_id })[1].name

      local lsp

      if args.data.params.value.kind == 'end' then
        lsp = {
          prog = nil,
        }
      else
        lsp = {
          prog = args.data.params.value.percentage,
        }
      end

      state.lsp.collection[lsp_name] = lsp
      update_lsp_state()
      vim.cmd.redrawstatus()
    end
  })
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufLeave' }, {
  callback = function()
    update_lsp_state()
  end
})

----------

if opts.inactive_white then
  vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = opts.colors.preto, bg = opts.colors.offwhite })
else
  vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'StatusLine' })
end

if opts.global_status_line then
  vim.o.laststatus = 3
else
  vim.o.laststatus = 2
end

----------

vim.o.statusline = "%!v:lua.require('statusline').render()"

----------

return {
  render = function ()
    -- This makes it dynamic, if I change to global or not global
    -- during a vim session, the status line will get redrawn accordingly.
    -- This literally will never happen, but anyways.
    local is_global = vim.o.laststatus == 3
    -- Change the colors of the statusline of non focused windows when
    -- not using a global status line.
    if not is_global and vim.api.nvim_get_current_win() ~= tonumber(vim.g.statusline_winid or 0) then
      return ' ' .. filename() .. '%=' .. filetype() .. lines()
    end

    update_mode_state()
    update_macro_state()

    return table.concat({
      status_line_color_a(),
      mode(),
      status_line_color_b(),
      filename(),
      status_line_color_c(),
      '%=',
      macro_recording(),
      '%=',
      diagnostic(),
      git_hunks(),
      git_diff(),
      -- The git_diff call ends with %* to reset its color.
      -- This was made so that what comes after, eg lsp_clients_names, don't
      -- get affected by it (like have colored fg, green, red etc).
      -- Unfortunately, this also means we need to reapply status_line_color_c().
      status_line_color_c(),
      lsp_clients_names(),
      status_line_color_b(),
      filetype(),
      status_line_color_a(),
      lines(),
    })
  end,
  state = state,
}
