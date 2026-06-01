local opts = {
  add_debug_addons = false,
  max_buffer_name_size = 35,
  no_name = '[No Name]',
  modified = '[+]',
  readonly = '[RO]',
  non_modifiable = '[-]',
  ellipsis = '…',
  ellipsis_width = nil,
  directory_separator = package.config:sub(1, 1),
  unlisted_buffers = {
    show_floating = true,
    show_normal = true,
    -- Whitelisted is necessary but not sufficient condition to show
    -- the buffer in tabline.
    -- After the ft passes the whitelist, it
    whitelist_ft_names = {
      -- If you pass "true", it derives the name shown in tabline by the
      -- filetype. It capitalizes the first character and wraps in braces [].
      -- If you pass a string, it uses that string exactly.
      -- If you pass false, it wont show that filetype.
      -- help = true
      netrw = 'Netrw',
      help = 'Help',
      blame = 'Blame',
      fzf = 'Fzf',
      NvimTree = 'NvimTree',
    },
  },
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
  pending_delete = {},
}

if opts.add_debug_addons then
  vim.keymap.set('n', '<C-g>', function() return P(state.debug) end)
end

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
    -- Since the nvim_set_current_buf triggers a redraw,
    -- the state is recalculated right after anyways,
    -- so all of these manual state updates are redundant.
    -- But I also never use it. And it is pretty much harmless anyways.
    -- So I left them there.
    state.current_bufnr = bufnr
    for i, buf in ipairs(state.buffers) do
      if buf.bufnr == bufnr then
        state.current_i = i
      end
    end
  end
end

require('tabline.user_commands').create(state)
require('tabline.keymappings').set()

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
  debug = state.debug,
}
