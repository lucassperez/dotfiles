-- Original:
-- https://github.com/divineLush/awesomewm-dumb-widgets/blob/master/bright.lua
-------------------------------------------------
-- Bright widget
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')

local text = wibox.widget({
    font = 'FontAwesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#aaeb6a')

local function calculateNearest5(string)
  local number = tonumber(string)
  local unit = number % 10
  local deci = number // 10
  local result

  if number < 2.5 then
    result = 1
  elseif unit >= 7.5 then
    result = (deci + 1) * 10
  elseif unit >= 2.5 then
    result = deci * 10 + 5
  else
    result = deci * 10
  end

  result = math.floor(result)

  return result
end

local function set_widget()
  awful.spawn.easy_async(
  'light',
  function(out)
    local num_val = calculateNearest5(out)
    text:set_text(' '..num_val..'%')
  end
  )
end

set_widget()

function widget:update_widget(cmd)
  cmd = cmd or 'light'
  awful.spawn.easy_async(cmd, set_widget)
end

function widget:inc(delta)
  delta = delta or 5
  widget:update_widget('light -A '..delta..'%')
  -- widget:update_widget('xbacklight -inc '..delta)
end

function widget:dec(delta)
  delta = delta or 5
  widget:update_widget('light -U '..delta..'%')
  -- widget:update_widget('xbacklight -dec '..delta)
end

-- Set brightness to the nearest multiple of 5
-- 34 becomes 35, 11 becomes 10 etc.
-- Numbers less than 2.5 stop at 1 to avoid the screen
-- of going completely black.
function widget:roundNearest5()
  -- local brightness = calculateNearest5(io.popen('xbacklight'):read())
  local result = calculateNearest5(io.popen('light'):read())

  widget:update_widget('light -S '..result)
  -- widget:update_widget('xbacklight -set '..result)
end

widget:connect_signal('button::press', function(_,_,_,button)
  if (button == 1 or button == 3) then widget:roundNearest5()
  -- elseif (button == 2) then widget:update_widget('xbacklight -set 50')
  elseif (button == 2) then widget:update_widget('light -S 50')
  elseif (button == 4) then widget:inc(5)
  elseif (button == 5) then widget:dec(5) end
end)

return widget
