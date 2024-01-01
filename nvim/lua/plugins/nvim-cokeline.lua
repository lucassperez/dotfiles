local is_picking_focus = require('cokeline.mappings').is_picking_focus
local is_picking_close = require('cokeline.mappings').is_picking_close

vim.keymap.set('n', '<leader>P', '<Plug>(cokeline-pick-focus)', { desc = '[Cokeline] Seleciona um buffer para ter o foco' })
vim.keymap.set('n', '<A-Q>', '<Plug>(cokeline-switch-prev)', { desc = '[Cokeline] Move o buffer atual para trás na tabline' })
vim.keymap.set('n', '<A-W>', '<Plug>(cokeline-switch-next)', { desc = '[Cokeline] Move o buffer atual para frente na tabline' })

-- https://github.com/willothy/nvim-cokeline/issues/59
-- [count]<A-q> e [count]<A-w> vai para o buffer de índice [count]
vim.keymap.set('n', '<A-q>', function()
  return ('<Plug>(cokeline-focus-%s)'):format(vim.v.count > 0 and vim.v.count or 'prev')
end, { expr = true, desc = '[Cokeline] Mostra o buffer anterior' })

vim.keymap.set('n', '<A-w>', function()
  return ('<Plug>(cokeline-focus-%s)'):format(vim.v.count > 0 and vim.v.count or 'next')
end, { expr = true, desc = '[Cokeline] Mostra o próximo buffer' })

vim.keymap.set('n', '<leader>q', function()
  return ('<Plug>(cokeline-focus-%s)'):format(vim.v.count > 0 and vim.v.count or 'prev')
end, { expr = true, desc = '[Cokeline] Mostra o buffer anterior' })

vim.keymap.set('n', '<leader>w', function()
  return ('<Plug>(cokeline-focus-%s)'):format(vim.v.count > 0 and vim.v.count or 'next')
end, { expr = true, desc = '[Cokeline] Mostra o próximo buffer' })

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

require('cokeline').setup({
  show_if_buffers_are_at_least = 0,
  buffers = {
    focus_on_delete = 'prev',
    delete_on_right_click = false,
  },
  pick = {
    use_filename = false,
    letters = 'asdfhjklgçnmxcvbziowerutyqpASDFHJKLGÇNMXCVBZIOWERUTYQP',
  },
  default_hl = {
    fg = function(buffer)
      if buffer.is_focused then return colors.fg.active end

      local current_tab = vim.fn.tabpagenr()
      local all_windows = vim.fn.getwininfo()

      for _, w in pairs(all_windows) do
        if w.tabnr == current_tab then
          if vim.fn.getbufinfo(w.bufnr)[1].name == buffer.path then return colors.fg.visible end
        end
      end
      return colors.fg.inactive
    end,
    bg = function(buffer)
      if buffer.is_focused then return colors.bg.active end

      local current_tab = vim.fn.tabpagenr()
      local all_windows = vim.fn.getwininfo()

      for _, w in pairs(all_windows) do
        if w.tabnr == current_tab then
          if vim.fn.getbufinfo(w.bufnr)[1].name == buffer.path then return colors.bg.visible end
        end
      end
      return colors.bg.inactive
    end,
  },
  components = {
    { text = ' ' },
    {
      text = function(buffer)
        if is_picking_focus() or is_picking_close() then return buffer.pick_letter end
        -- If the very first character is a mulibyte character (like ç),
        -- using regular lua (str:sub(1, 1)) will give a weird character.
        return vim.fn.strcharpart(buffer.unique_prefix .. buffer.filename, 0, 1)
      end,
      fg = function()
        if is_picking_focus() or is_picking_close() then return 'red' end
      end,
    },
    {
      text = function(buffer)
        local r = buffer.unique_prefix .. buffer.filename
        -- Should theoretically be #r - 1, but for
        -- some reason I just feel better with #r.
        r = vim.fn.strcharpart(r, 1, #r)

        -- Manual truncation
        -- I'm doing manual truncation because the truncation is not playing
        -- very well with the last component that I'm using just as a right
        -- padding to decide if it should truncate or not. The last component
        -- is simply not showing up ):

        -- local max_buffer_name_size = _G.cokeline.config.rendering.max_buffer_width
        local max_buffer_name_size = 30
        -- Plus 1 because r is everything but the first letter,
        -- so we have to count that in
        if #r + 1 > max_buffer_name_size then
          -- Get only as many last letters as necessary so the full thing
          -- is "max_buffer_name_size" long, that is,
          -- if max_buffer_name_size is 30, then the last 28 letters, because
          -- when adding the ellipsis and the first letter, it gets to 30.
          -- Also remember that the first letter is in the other component.
          r = '…' .. vim.fn.strcharpart(r, #r - (max_buffer_name_size - 2), #r)
        end

        -- If I don't wan't to count the modified icon in the
        -- truncation calculation, I add it after the truncation.
        if buffer.is_modified then r = r .. '[+]' end

        return r
      end,
    },
    { text = ' ' },
  },
  rhs = {
    {
      fg = '#599eff',
      bg = colors.bg.active,
      style = 'bold',
      text = function()
        local total_tabs = vim.fn.tabpagenr('$')
        -- if total_tabs == 1 then return '' end
        -- I just think it looks a little better without a right padding :shrug:
        return ' ' .. vim.fn.tabpagenr() .. '/' .. total_tabs
      end,
    },
  },
})
