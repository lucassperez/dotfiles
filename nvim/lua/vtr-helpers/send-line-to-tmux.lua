-- Since vim.fn.mode() always returns 'n', the mode has to be passed as an
-- argument when this function is called
-- https://vi.stackexchange.com/questions/8789/mode-always-seems-to-return-n

-- Unfortunately, Vtr itself already have a command VtrSendLinesToRunner that
-- already do exactly this. But I like mine.
-- My version does not strips leading white spaces. This usuallly looks ugly,
-- but at least blocks are kept indented. I could use the g:VtrStripLeadingWhitespace
-- option and the regular VtrSendLinesToRunner, but it is too late now
function _G.sendLinesToTmux(mode)
  mode = mode or vim.fn.mode()
  text = ''
  if mode == 'normal' or mode == 'n' then
    text = vim.fn.getline('.')
  elseif mode == 'visual' or mode == 'v' then
    start  = tonumber(vim.fn.getpos("'<")[2])
    finish = tonumber(vim.fn.getpos("'>")[2])
    for i = start, finish - 1 do
      text = text..vim.fn.getline(i)..'\n'
    end
    text = text..vim.fn.getline(finish)
  else
    return
  end

  local old_config = vim.g.VtrClearBeforeSend
  vim.g.VtrClearBeforeSend = 0
  vim.fn.VtrSendCommand(text)
  vim.g.VtrClearBeforeSend = old_config
end
