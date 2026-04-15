local opts = {
  max_buffer_name_size = 35,
  no_name = '[No Name]',
  modified = '[+]',
  readonly = '[RO]',
  ellipsis = '…',
  ellipsis_width = nil,
  directory_separator = package.config:sub(1, 1),
  colors = {
    fg = {
      current = '#efefef',
      visible = '#efefef',
      invisible = '#616163',
      -- tab_counter = '#599eff',
      -- tab_counter = '#c86c5f',
      -- tab_counter = '#789c57',
      -- tab_counter = '#a7c080',
      tab_counter = '#e4c257',
    },
    bg = {
      current = '#292e35',
      visible = '#6c6c6c',
      invisible = '#2e3436',
      tab_counter = '#292e35',
    },
  },
  visibility_to_hl = {
    [0] = '%#TablineInvisible#',
    [1] = '%#TablineVisible#',
    [2] = '%#TablineCurrent#',
  },
}
opts.ellipsis_width = vim.fn.strdisplaywidth(opts.ellipsis)

local state = {
  current_i = 0,
  current_bufnr = 0,
  buffers = {},
  tab_len = 0,
  tab_str = nil,
  buf_tree_flattened = nil,
  buf_tree_cache_key = nil,
}

--------------------------------------------------
--------------------------------------------------
--------------------------------------------------

local function goto_buffer(direction)
  local new_i = state.current_i + direction

  if new_i > #state.buffers then
    new_i = 1
  elseif new_i < 1 then
    new_i = #state.buffers
  end
  state.current_i = new_i
  state.current_bufnr = state.buffers[new_i].bufnr

  -- Setting current buffer already triggers a redraw,
  -- so no need to call vim.cmd.redrawtabline()
  vim.api.nvim_set_current_buf(state.current_bufnr)
end

local function move_current_buffer(direction)
  local new_i = state.current_i + direction

  if new_i > #state.buffers then
    new_i = 1
  elseif new_i < 1 then
    new_i = #state.buffers
  end

  local tmp = state.buffers[state.current_i]
  state.buffers[state.current_i] = state.buffers[new_i]
  state.buffers[new_i] = tmp
  vim.cmd.redrawtabline()
end

local function goto_buffer_by_i(i)
  if type(i) == 'string' then
    if (i):match('^[Ff][Ii][Rr][Ss][Tt]$') then
      i = -1
    elseif (i):match('^[Ll][Aa][Ss][Tt]$') then
      i = 0
    else
      i = tonumber(i)
    end
  else
    i = tonumber(i)
  end

  if not i then
    vim.notify('Invalid buffer index: ' .. vim.inspect(i), vim.log.levels.ERROR)
    return
  end

  local buf
  if i == 0 or i > #state.buffers then
    buf = state.buffers[#state.buffers]
  elseif i < 0 then
    buf = state.buffers[1]
  else
    buf = state.buffers[i]
  end

  if not buf then
    vim.notify('Could not find buf somehow', vim.log.levels.ERROR)
    return
  end

  state.current_i = i
  state.current_bufnr = buf.bufnr
  vim.api.nvim_set_current_buf(buf.bufnr)
end

--------------------------------------------------
--------------------------------------------------
--------------------------------------------------

vim.api.nvim_create_user_command('BPrevious', function () goto_buffer(-1) end, {})
vim.api.nvim_create_user_command('BNext', function () goto_buffer(1) end, {})

vim.api.nvim_create_user_command('BMovePrevious', function () move_current_buffer(-1) end, {})
vim.api.nvim_create_user_command('BMoveNext', function () move_current_buffer(1) end, {})

local command_buf_options = {
  nargs = 1,
  complete = function()
    local items = { 'first', 'last' }
    local i = 3
    while i <= #state.buffers + 2 do
      items[i] = tostring(i - 2)
      i = i + 1
    end
    return items
  end
}

vim.api.nvim_create_user_command('B', function(cmd_args)
  goto_buffer_by_i(cmd_args.args)
end, command_buf_options)

vim.api.nvim_create_user_command('Buffer', function(cmd_args)
  goto_buffer_by_i(cmd_args.args)
end, command_buf_options)


--------------------------------------------------

vim.keymap.set('n', '<A-Q>', ':BMovePrevious<CR>', { desc = '[Tabline] Move o buffer atual para trás na tabline' })
vim.keymap.set('n', '<A-W>', ':BMoveNext<CR>', { desc = '[Tabline] Move o buffer atual para trás na tabline' })

vim.keymap.set('n', '<leader>q', ':BPrevious<CR>')
vim.keymap.set('n', '<leader>w', ':BNext<CR>')

vim.keymap.set('n', '<A-q>', ':BPrevious<CR>', { desc = 'Mostra o buffer anterior' })
vim.keymap.set('n', '<A-w>', ':BNext<CR>', { desc = 'Mostra o buffer anterior' })

-- Override default mapping
vim.keymap.set('n', '[b', ':BPrevious<CR>', { silent = true, desc = 'Mostra o buffer anterior' })
vim.keymap.set('n', ']b', ':BNext<CR>', { silent = true, desc = 'Mostra o buffer anterior' })

--------------------------------------------------

vim.api.nvim_set_hl(0, 'TablineCurrent', {
  fg = opts.colors.fg.current,
  bg = opts.colors.bg.current,
})
vim.api.nvim_set_hl(0, 'TablineVisible', {
  fg = opts.colors.fg.visible,
  bg = opts.colors.bg.visible,
})
vim.api.nvim_set_hl(0, 'TablineInvisible', {
  fg = opts.colors.fg.invisible,
  bg = opts.colors.bg.invisible,
})
vim.api.nvim_set_hl(0, 'TablineTabCounter', {
  fg = opts.colors.fg.tab_counter,
  bg = opts.colors.bg.tab_counter,
  bold = true,
})

--------------------------------------------------

-- showtabline possible values:
--   0 never
--   1 only if at least 2 tab pages
--   2 always
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require('tabline').render()"

--------------------------------------------------

_G.MyTabline = {}
function _G.MyTabline.click_handler(bufnr, _, button)
  -- Third argument received by click_handler is the mouse button used.
  -- l|r|m: l for left, r for right and m for middle.
  if button == 'l' then
    vim.api.nvim_set_current_buf(bufnr)
  end
  state.current_bufnr = bufnr
  for i, buf in ipairs(state.buffers) do
    if buf.bufnr == bufnr then
      state.current_i = i
    end
  end
end

return {
  render = function()
    require('tabline.state').update_state(state, opts)

    local left = require('tabline.renderer').new(state, opts).buffers_paths()

    return table.concat({
      left,
      '%#TablineFill#',
      '%=',
      '%#TablineTabCounter#',
      state.tab_str
    })
  end,
  state = state,
}
