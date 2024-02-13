local wibox = require('wibox')
local awful = require('awful')
local watch = awful.widget.watch

local widget = wibox.widget.background()

local opts = {
  show_seconds = false,
  time_cmd = 'date "+%a %d %b %H %M %S"',
}

local function calculate_and_set_widget_output(stdout)
  -- Sadly, %w does not match "á", present in "sábado" (saturday, in portuguese).
  local weekday, day, month, hours, minutes, seconds = stdout:match('([%wá]*) (%w*) (%w*) (%w*) (%w*) (%w*)')

  local date = ' ' .. weekday .. ' ' .. day .. ' ' .. month
  local time = ' ' .. hours .. ':' .. minutes

  if opts.show_seconds then time = time .. ':' .. seconds end

  local markup_date = string.format([[<span foreground="#6fb4d6">%s</span>]], date)
  local markup_time = string.format([[<span foreground="#ffffff">%s</span>]], time)

  local datetime = wibox.widget({
    markup = markup_date .. '  ' .. markup_time .. '  ',
    font = 'FontAwesome 11',
    widget = wibox.widget.textbox,
  })
  widget:set_widget(datetime)
end

watch(opts.time_cmd, 1, function(_widget, stdout, _stderr, _exitreason, _exitcode)
  calculate_and_set_widget_output(stdout)
end, widget)

-- Calendar pop up on click
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/calendar-widget
local calendar_widget = require('widgets.calendar')({
  theme = 'my_theme',
  placement = 'top_right',
  radius = 12,
  start_sunday = true,
})

local function draw_widget()
  awful.spawn.easy_async(opts.time_cmd, calculate_and_set_widget_output)
end

widget:connect_signal('button::press', function(_, _, _, button)
  if button == 1 or button == 3 then
    awful.spawn('zenity --calendar --text= >/dev/null')
    -- awful.widget.calendar_popup.month():toggle()
  elseif button == 2 then
    calendar_widget.toggle()
  elseif button == 4 or button == 5 then
    opts.show_seconds = not opts.show_seconds
    awful.spawn.easy_async(opts.time_cmd, draw_widget)
  end
end)

return widget
