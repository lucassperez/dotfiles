-- This does not work to, say, select commented lines. It would be nice to
-- enter visual mode, execute, say, gc, and then have it all selected.

-- https://github.com/numToStr/Comment.nvim/issues/22#issuecomment-1272569139
local utils = require('Comment.utils')
local function commented_lines_textobject()
  local cl = vim.api.nvim_win_get_cursor(0)[1] -- current line
  local range = { srow = cl, scol = 0, erow = cl, ecol = 0 }
  local ctx = {
    ctype = utils.ctype.linewise,
    range = range,
  }
  local cstr = require('Comment.ft').calculate(ctx) or vim.bo.commentstring
  local ll, rr = utils.unwrap_cstr(cstr)
  local padding = true
  local is_commented = utils.is_commented(ll, rr, padding)

  local line = vim.api.nvim_buf_get_lines(0, cl - 1, cl, false)
  if next(line) == nil or not is_commented(line[1]) then
    return
  end

  local rs, re = cl, cl -- range start and end
  repeat
    rs = rs - 1
    line = vim.api.nvim_buf_get_lines(0, rs - 1, rs, false)
  until next(line) == nil or not is_commented(line[1])
  rs = rs + 1
  repeat
    re = re + 1
    line = vim.api.nvim_buf_get_lines(0, re - 1, re, false)
  until next(line) == nil or not is_commented(line[1])
  re = re - 1

  vim.fn.execute('normal! ' .. rs .. 'GV' .. re .. 'G')
end

vim.keymap.set('o', 'gc', commented_lines_textobject, { silent = true, desc = 'Textobject for adjacent commented lines' })
vim.keymap.set('o', 'u', commented_lines_textobject, { silent = true, desc = 'Textobject for adjacent commented lines' })

local ft = require('Comment.ft')
-- filetype and (commentstring or { commentrings })
-- ft.set('template', { '<!--%s-->', '<!--%s-->' })
-- ft.template = { '<!--%s-->', '<!--%s-->' }
ft.template = { '<!--%s-->', '{{/*%s*/}}' }

-- This would also be valid:
-- ft({ 'type1', 'type2', }, { 'line_commentstring', 'block_commentstring', })
-- ft({ 'c', 'go', }, { '//%s', '/*%s*/', })

require('Comment').setup({
  padding = true,

  -- Don't comment blank lines with '^$'.
  ignore = '^$',

  -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
  -- Is this really working?
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),

  toggler = {
    -- The default gbc always confuses me, so I made this. I guess I can't use
    -- the b text object like this, but oh well.
    block = 'gbb',
  },
})
