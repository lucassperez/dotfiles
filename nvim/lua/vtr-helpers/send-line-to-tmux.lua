-- Since vim.fn.mode() always returns 'n', the mode has to be passed as an
-- argument when this function is called
-- https://vi.stackexchange.com/questions/8789/mode-always-seems-to-return-n
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
  vim.fn.VtrSendCommand(text)
end
