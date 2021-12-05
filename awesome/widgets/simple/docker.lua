local wibox = require('wibox')
local watch = require('awful.widget.watch')

local text = wibox.widget({
    font = 'Font Awesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#0DB7ED')

watch(
  -- TODO Find out why piping docker ps to wc -l doesn't work.
  --      Maybe the pipe is not supported.
  'docker ps -q',
  5,
  function(widget, stdout, stderr, exitreason, exitcode)
    local _, count = stdout:gsub('\n', '\n')
    msg = '🐳 '..count
    text:set_text(msg)
  end,
  widget
)

return widget
