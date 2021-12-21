-- Original:
-- https://github.com/divineLush/awesomewm-dumb-widgets/blob/master/bright.lua
-------------------------------------------------
-- Bright widget
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')

local text = wibox.widget({
    font = 'Hack 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#aaeb6a')

local function set_widget()
  awful.spawn.easy_async(
  'xbacklight',
  function(out)
    -- local raw_val = string.sub(out, 1, -2)
    -- local num_val = math.floor(tonumber(raw_val))
    local num_val = math.floor(tonumber(out))
    text:set_text(' '..num_val..'%')
  end
  )
end

set_widget()

local function update_widget(cmd)
  awful.spawn.easy_async(cmd, set_widget)
end

function widget:inc(delta)
  delta = delta or 5
  -- update_widget('light -A '..delta..'%')
  update_widget('xbacklight -inc '..delta)
end

function widget:dec(delta)
  delta = delta or 5
  -- update_widget('light -U '..delta..'%')
  update_widget('xbacklight -dec '..delta)
end

widget:connect_signal('button::press', function(_,_,_,button)
  if (button == 4) then widget:inc(5)
  elseif (button == 5) then widget:dec(5) end
end)

return widget
