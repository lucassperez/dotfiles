-- http://colby.id.au/calculating-cpu-usage-from-proc-stat/
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget

local awful = require('awful')
local wibox = require('wibox')
local watch = require('awful.widget.watch')
local naughty = require('naughty')

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#de6347')

-- local command = [[grep '^cpu.' /proc/stat; ps -eo 'pid:10,pcpu:5,pmem:5,comm:30,cmd' --sort=-pcpu | grep -v '[p]s' | grep -v '[g]rep' | head -11]]
local command = [[grep '^cpu.' /proc/stat]]

watch(command, 10, function(widget, stdout, stderr, exitreason, exitcode)
  naughty.notify({
    title = 'T: '..tostring(stdout == ''),
    text = stdout,
  })
end, widget)

return widget
