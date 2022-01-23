local wibox = require('wibox')
local awful = require('awful')
local watch = awful.widget.watch

local widget = wibox.widget.background()

watch(
  'date "+%a %d %b %H %M"',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    -- Sadly, %w does not match "á", present in "sábado" (saturday, in portuguese).
    local weekday, day, month, hours, minutes = stdout:match('([%wá]*) (%w*) (%w*) (%w*) (%w*)')

    local date = ' '..weekday..' '..day..' '..month
    local time = ' '..hours..':'..minutes

    local datetime = wibox.widget({
      markup = '<span foreground="#6fb4d6">'..date..'</span>  <span foreground="#ffffff">'..time..'</span>',
      font = 'Hack 11',
      widget = wibox.widget.textbox,
    })
    widget:set_widget(datetime)
  end,
  widget
)

-- Calendar pop up on click
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/calendar-widget
local calendar_widget = require('widgets.calendar')({
  theme = 'my_theme',
  placement = 'top_right',
  radius = 12,
  start_sunday = true
})

widget:connect_signal(
  'button::press',
  function(_, _, _, button)
    if button == 2 then calendar_widget.toggle() end
  end
)

widget:connect_signal(
  'button::press',
  function(_, _, _, button)
    if button == 1 or button == 3 then
      awful.spawn('zenity --calendar --text= >/dev/null')
    end
  end
)

return widget
