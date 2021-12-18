local wibox = require('wibox')
local watch = require('awful.widget.watch')

local text = wibox.widget({
    font = 'Hack 12',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#FFFFFF')

watch(
  -- TODO Find out why piping docker ps to wc -l doesn't work.
  --      Maybe the pipe is not supported.
  'date +%H:%M',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local msg = ' '..stdout
    text:set_text(msg)
  end,
  widget
)

-- Calendar pop up when click on clock
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/calendar-widget
local calendar_widget = require("widgets.calendar")
local cw = calendar_widget({
  theme = 'naughty',
  placement = 'top_right',
  radius = 12,
  start_sunday = true
})
widget:connect_signal(
  "button::press",
  function(_, _, _, button)
    if button == 1 then cw.toggle() end
  end
)

return widget
