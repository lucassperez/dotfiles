-- Original:
-- https://github.com/divineLush/awesomewm-dumb-widgets/blob/master/battery.lua
-------------------------------------------------
-- Battery widget
-------------------------------------------------

local wibox = require('wibox')
local watch = require('awful.widget.watch')
local naughty = require('naughty')

local text = wibox.widget({
    font = 'Font Awesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)

watch(
  'acpi -b',
  5,
  function(widget, stdout, stderr, exitreason, exitcode)
    local state, percentage  = stdout:match('Battery %d+: (%w*), (%d*)%%')
    percentage = tonumber(percentage)

    if percentage <= 10 then
      bg = '#ff0000'
      color = '#FFFFFF'
    elseif percentage <= 20 then
      -- I have to set bg as nil on other percentages because if bg was previously
      -- set, even if I charge my battery, the old bg is still going to prevail
      color = '#FF3300'
      bg = nil
    elseif percentage <= 30 then
      color = '#FF6600'
    elseif percentage <= 40 then
      color = '#FF9900'
    elseif percentage <= 50 then
      color = '#FFCC00'
    elseif percentage <= 60 then
      color = '#FFFF00'
    elseif percentage <= 70 then
      color = '#FFFF33'
    elseif percentage <= 80 then
      color = '#FFFF66'
    else
      color = '#FFFFFF'
    end

    -- Full icon: higher than 90
    -- Empty icon: lower than 15
    -- Between 90 and 15 there are 75 numbers to be divided in
    -- three intervals, since we have 3 icons left: 3/4, 1/2 and 1/4
    -- 75/3 = 25 for each interval
    -- So the other icons will happen in these intervals:
    -- 3/4 icon: [65, 90)
    -- 1/2 icon: [40, 65)
    -- 1/4 icon: [15, 40)
    if state == 'Charging' then
      msg = ' '..percentage..'%'
      bg = nil
      color = '#00ff00'
    elseif percentage >= 90 then
      msg = ' '..percentage..'%'
    elseif percentage >= 65 then
      msg = ' '..percentage..'%'
    elseif percentage >= 40 then
      msg = ' '..percentage..'%'
    elseif percentage >= 15 then
      msg = ' '..percentage..'%'
    else
      msg = ' '..percentage..'%'
    end

    text:set_text(msg)
    widget:set_fg(color)
    widget:set_bg(bg)
  end,
  widget
)

widget:connect_signal(
  'button::press',
  function(_, _, _, button)
    if button == 1 or button == 3 then
      local text, urgency

      local battery = io.popen('acpi -b'):read()
      local state, percentage, time_left, message =
        battery:match('Battery %d+: (%w*), (%d*)%%, (%d%d:%d%d):%d%d (.*)')

      if state == 'Full' then
        text = '(:'
      else
        text = time_left..' '..message
      end

      if tonumber(percentage) <= 15 and state ~= 'Charging' then
          urgency = 'critical'
          text = text..'\nDo something, quick!'
          bg = '#ff0000' -- since the urgency doesn't seem to work, I did this silliness
      else
        urgency = 'low'
      end

      naughty.notify({
        title = state,
        text = text,
        urgency = urgency, -- this doesn't work, how cool is that
        bg = bg,
      })
    end
  end
)

return widget
