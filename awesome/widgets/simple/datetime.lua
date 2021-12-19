local wibox = require('wibox')
local watch = require('awful.widget.watch')

-- I prefered this rather than the changing locale before os.date command
local locale_dict = {
  Sun = 'dom',
  Mon = 'seg',
  Tue = 'ter',
  Wed = 'qua',
  Thu = 'qui',
  Fri = 'sex',
  Sat = 'sáb',
  Jan = 'jan',
  Feb = 'fev',
  Mar = 'mar',
  Apr = 'abr',
  May = 'mai',
  Jun = 'jun',
  Jul = 'jul',
  Aug = 'ago',
  Sep = 'set',
  Oct = 'out',
  Nov = 'nov',
  Dec = 'dez',
}

local widget = wibox.widget.background()

watch(
  'date +%a %d %b %H %M',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    -- Why can't I use the `stdout` variable? ):
    local date = os.date('%a %d %b %H %M')
    local weekday, day, month, hours, minutes = date:match('(%w*) (%w*) (%w*) (%w*) (%w*)')

    local date = ' '..locale_dict[weekday]..' '..day..' '..locale_dict[month]
    local time = ' '..hours..':'..minutes

    local datetime = wibox.widget({
      markup = '<span foreground="#6fb4d6">'..date..'</span>  <span foreground="#ffffff">'..time..'</span>',
      font = 'Hack 12',
      widget = wibox.widget.textbox,
    })
    widget:set_widget(datetime)
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
    if button == 1 or button == 3 then cw.toggle() end
  end
)

return widget
