--- Dependencies:
--- xsct
--- https://github.com/faf0/sct

local awful = require('awful')
local wibox = require('wibox')

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#999999')

local function calculate_widget_output(out)
  local temperature = out:match('^Screen [0-9]+: temperature ~ ([0-9]+)')
  local string_temperature = string.format(' %.1f', temperature / 1000)
  text:set_text(string_temperature)
end

local function draw_widget()
  awful.spawn.easy_async('xsct', calculate_widget_output)
end

draw_widget()
awful.widget.watch('xsct', 1, function(_, stdout) calculate_widget_output(stdout) end, widget)

function widget:update_widget(cmd)
  cmd = cmd or 'xsct'
  awful.spawn.easy_async(cmd, draw_widget)
end

function widget:inc(delta)
  delta = delta or 5
  widget:update_widget('xsct -d ' .. delta)
end

function widget:dec(delta)
  delta = delta or 5
  if delta > 0 then delta = -delta end
  widget:update_widget('xsct -d ' .. delta)
end

function widget:set(val)
  val = val or 5250
  widget:update_widget('xsct ' .. val)
end

widget:connect_signal('button::press', function(_, _, _, button)
  if (button == 2) then widget:update_widget('xsct 5250')
  elseif (button == 4) then widget:inc(500)
  elseif (button == 5) then widget:dec(500) end
end)

return widget
