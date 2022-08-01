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
    local state, percentage, rest = stdout:match('Battery %d+: (%w*), (%d*)%%')
    local percentage = tonumber(percentage)

    local message, color, bg

    if percentage <= 10 then
      bg = '#ff0000'
      color = '#ffffff'
    elseif percentage <= 20 then
      -- I have to set bg as nil on other percentages because if bg was
      -- previously set, even if I charge my battery, the old bg is still going
      -- to prevail
      color = '#ff3300'
      bg = nil
    elseif percentage <= 30 then
      color = '#ff6600'
      last_battery_warn = nil
    elseif percentage <= 40 then
      -- if was_higher_than_twenty then
      --   should_send_message = true
      --   was_higher_than_twenty = false
      -- end
      color = '#ff9900'
    elseif percentage <= 50 then
      -- should_send_message = false
      -- was_higher_than_twenty = true
      color = '#ffcc00'
    elseif percentage <= 60 then
      color = '#ffff00'
    elseif percentage <= 70 then
      color = '#ffff33'
    elseif percentage <= 80 then
      color = '#ffff66'
    else
      color = '#ffffff'
    end

    -- Full icon: higher than or equal to 90
    -- Empty icon: lower than or equal to 20
    -- Between 90 and 20 there are 69 numbers to be divided in
    -- three intervals, since we have 3 icons left: 3/4, 1/2 and 1/4
    -- 69/3 = 23 for each interval
    -- So the other icons will happen in these intervals:
    -- 3/4 icon: [67, 90)
    -- 1/2 icon: [44, 67)
    -- 1/4 icon: [20, 44)
    if state == 'Unknown' then
      message = ' '..percentage..'%'
    elseif state == 'Full' then
      color = "#ffffff"
      message = ' '..percentage..'%'
    elseif state == 'Charging' then
      message = ' '..percentage..'%'
      color = '#00ff00'
    elseif percentage >= 90 then
      message = ' '..percentage..'%'
    elseif percentage >= 67 then
      message = ' '..percentage..'%'
    elseif percentage >= 44 then
      message = ' '..percentage..'%'
    elseif percentage >= 20 then
      message = ' '..percentage..'%'
    else
      message = ' '..percentage..'%'
    end

    text:set_text(message)
    widget:set_fg(color)
    widget:set_bg(bg)

    -- if should_send_message and state ~= 'Charging'then
    if status ~= 'Charging' and
       percentage <= 20 and
       (last_battery_warn == nil or os.difftime(os.time(), last_battery_warn) > 300) -- 5 minutes since last warning
    then
      naughty.notify({
        title = '\nBateria baixa!',
        text = tostring(percentage)..'%',
        urgency = 'critical', -- this doesn't work, how cool is that
        timeout = 300,
        position = 'top_middle',
        height = 80,
        ignore_suspend = true, -- do I really want this?
        bg = '#ff0000',
      })
      -- should_send_message = false
      last_battery_warn = os.time()
    end
  end,
  widget
)

widget:connect_signal(
  'button::press',
  function(_, _, _, button)
    if button == 1 or button == 3 then
      local text, urgency

      local battery = io.popen('acpi -b'):read()
      local state, percentage = battery:match('Battery %d+: (%w*), (%d*)%%')

      if state == 'Full' then
        text = '(:'
      elseif state == 'Unknown' then
        text = 'Time left unknown 🤔'
      else
        local hours_left, minutes_left, message = battery:match('(%d%d):(%d%d):%d%d (.*)')
        local time_left
        if hours_left == '00' then
          time_left = minutes_left:gsub('^0', '')..' minutes'
        elseif minutes_left == '00' then
          time_left = hours_left:gsub('^0', '').. ' hours'
        else
          time_left = hours_left:gsub('^0', '').. ' hours and '..minutes_left:gsub('^0', '')..' minutes'
        end

        if message then
          text = time_left..' '..message
        else
          text = time_left
        end
      end

      if percentage and tonumber(percentage) <= 20 and state ~= 'Charging' then
        urgency = 'critical'
        text = text..'\nDo something, quick!'
        bg = '#ff0000' -- since the urgency doesn't seem to work, I did this silliness
      else
        urgency = 'low'
      end

      naughty.notify({
        title = percentage..'% '..state,
        text = text,
        urgency = urgency, -- this doesn't work, how cool is that
        bg = bg,
      })
    end
  end
)

return widget
