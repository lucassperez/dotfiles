local awful = require('awful')
local wibox = require('wibox')

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#999999')

local function set_widget()
  awful.spawn.easy_async(
    'xsct',
    function(out)
      local temperature = out:match('^Screen [0-9]+: temperature ~ ([0-9]+)')
      local string_temperature = string.format(' %.1f', temperature / 1000)
      text:set_text(string_temperature)
    end
  )
end

set_widget()

function widget:update_widget(cmd)
  cmd = cmd or 'xsct'
  awful.spawn.easy_async(cmd, set_widget)
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

widget:connect_signal('button::press', function(_, _, _, button)
  if (button == 2) then widget:update_widget('xsct 5250')
  elseif (button == 4) then widget:inc(500)
  elseif (button == 5) then widget:dec(500) end
end)

return widget
