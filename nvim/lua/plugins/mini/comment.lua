require('mini.comment').setup({
  mappings = {
    textobject = 'u',
  },
  options = {
    ignore_blank_line = true,

    -- My custom option used in the monkey patch below.
    ignore_blank_line_textobject = false,

    custom_commentstring = function()
      return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
    end,
  },
})

local original_textobject = MiniComment.textobject
-- I know it is duplicated, I'm monkey patching it.
---@diagnostic disable-next-line: duplicate-set-field
MiniComment.textobject = function()
  local ibl_og = MiniComment.config.options.ignore_blank_line
  local ibl_to = MiniComment.config.options.ignore_blank_line_textobject

  if ibl_to ~= nil and ibl_og ~= ibl_to then
    MiniComment.config.options.ignore_blank_line = ibl_to
    local ok, err = pcall(original_textobject)
    MiniComment.config.options.ignore_blank_line = ibl_og
    if not ok then
      error(err)
    end
  else
    original_textobject()
  end
end
