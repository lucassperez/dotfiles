local is_picking_focus = require('cokeline/mappings').is_picking_focus
local is_picking_close = require('cokeline/mappings').is_picking_close

vim.keymap.set('n', '<leader>p', '<Plug>(cokeline-pick-focus)',
               { desc = 'Seleciona um buffer para ter o foco', })

vim.keymap.set('n', '<A-Q>', '<Plug>(cokeline-switch-prev)',
               { desc = 'Move o buffer atual para trás na tabline', })

vim.keymap.set('n', '<A-W>', '<Plug>(cokeline-switch-next)',
               { desc = 'Move o buffer atual para frente na tabline', })

-- https://github.com/willothy/nvim-cokeline/issues/59
-- [count]<A-q> e [count]<A-w> vai para o buffer de índice [count]
vim.keymap.set('n', '<A-q>', function()
  if vim.v.count > 0 then
    return '<Plug>(cokeline-focus-' .. vim.v.count .. ')'
  else
    return ':bprevious<CR>'
  end
end, { expr = true, })

vim.keymap.set('n', '<A-w>', function()
  if vim.v.count > 0 then
    return '<Plug>(cokeline-focus-' .. vim.v.count .. ')'
  else
    return ':bnext<CR>'
  end
end, { expr = true, })

local colors = {
  fg = {
    active = '#efefef',
    inactive = '#616163',
    visible = '#efefef',
  },
  bg = {
    active = 'NONE',
    inactive = '#2e3436',
    visible = '#6c6c6c',
  },
}

vim.cmd('hi TabLine guibg=#bbc2cf')

require('cokeline').setup({
  show_if_buffers_are_at_least = 0,
  buffers = {
    focus_on_delete = 'prev',
    delete_on_right_click = false,
  },
  rendering = {
    max_buffer_width = 30,
  },
  pick = {
    use_filename = false,
    letters = 'asdfhjklgçnmxcvbziowerutyqpASDFHJKLGÇNMXCVBZIOWERUTYQP',
  },
  default_hl = {
    fg = function(buffer)
      if buffer.is_focused then
        return colors.fg.active
      end

      local current_tab = vim.fn.tabpagenr()
      local all_windows = vim.fn.getwininfo()

      for _, w in pairs(all_windows) do
        if w.tabnr == current_tab then
          if vim.fn.getbufinfo(w.bufnr)[1].name == buffer.path then
            return colors.fg.visible
          end
        end
      end
      return colors.fg.inactive
    end,
    bg = function(buffer)
      if buffer.is_focused then
        return colors.bg.active
      end

      local current_tab = vim.fn.tabpagenr()
      local all_windows = vim.fn.getwininfo()

      for _, w in pairs(all_windows) do
        if w.tabnr == current_tab then
          if vim.fn.getbufinfo(w.bufnr)[1].name == buffer.path then
            return colors.bg.visible
          end
        end
      end
      return colors.bg.inactive
    end,
  },
  components = {
    { text = ' ', },
    {
      text = function(buffer)
        if is_picking_focus() or is_picking_close() then
          return buffer.pick_letter
        end
        return (buffer.unique_prefix .. buffer.filename):sub(1, 1)
      end,
      fg = function()
        if is_picking_focus() or is_picking_close() then
          return 'red'
        end
      end,
    },
    {
      text = function(buffer)
        local r = buffer.unique_prefix .. buffer.filename
        -- Should theoretically be #r - 1, but for
        -- some reason I just feel better with #r.
        r = vim.fn.strcharpart(r, 1, #r)
        if buffer.is_modified then
          r = r .. '[+]'
        end
        return r
      end,
      truncation = { direction = 'left', },
    },
    { text = ' ', },
  },
  rhs = {
    {
      fg = '#599eff',
      bg = colors.bg.active,
      style = 'bold',
      text = function()
        local total_tabs = vim.fn.tabpagenr('$')
        if total_tabs == 1 then return '' end
        -- I just think it looks a little better without a right padding :shrug:
        return ' ' .. vim.fn.tabpagenr() .. '/' .. total_tabs
      end,
    },
  },
})
