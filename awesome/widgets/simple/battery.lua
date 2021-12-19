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
    -- local hours, minutes, seconds =
    --   string.match(stdout, 'Battery %d+: %w*, %d*%%, (%d%d):(%d%d):(%d%d)')

    if state == 'Charging' then
      msg = ' '..percentage..'%'
    elseif percentage >= 80 then
      msg = ' '..percentage..'%'
    elseif percentage >= 60 then
      msg = ' '..percentage..'%'
    elseif percentage >= 40 then
      msg = ' '..percentage..'%'
    elseif percentage >= 20 then
      msg = ' '..percentage..'%'
    else
      msg = ' '..percentage..'%'
    end

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

      if tonumber(percentage) <= 15 then
        urgency = 'critical'
        if state ~= 'Charging' then
          text = text..'\nDo something, quick!'
          bg = '#ff0000' -- since the urgency doesn't seem to work, I did this silliness
        end
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
