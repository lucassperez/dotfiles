local wibox = require('wibox')
local watch = require('awful.widget.watch')

local text = wibox.widget({
    font = 'FontAwesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#6fb4d6')

watch(
  'date',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local old_locale = os.getenv('LANG')
    os.setlocale('pt_BR.UTF-8')
    local msg = ' '..os.date('%a %d %b')
    os.setlocale(old_locale)

    text:set_text(msg)
  end,
  widget
)

-- Calendar pop up when click on clock
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/calendar-widget
local calendar_widget = require('widgets.calendar')
local cw = calendar_widget({
  theme = 'naughty',
  placement = 'top_right',
  radius = 12,
  start_sunday = true
})
widget:connect_signal(
  'button::press',
  function(_, _, _, button)
    if button == 1 then cw.toggle() end
  end
)

return widget
