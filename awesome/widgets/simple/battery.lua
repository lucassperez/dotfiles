-- Original:
-- https://github.com/divineLush/awesomewm-dumb-widgets/blob/master/battery.lua
-------------------------------------------------
-- Battery widget
-------------------------------------------------

local wibox = require('wibox')
local watch = require('awful.widget.watch')

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
    local state, percentage  =
      string.match(stdout, 'Battery %d+: (%w*), (%d*)%%')
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

    if percentage < 10 then
      color = '#FFFFFF'
    elseif percentage < 20 then
      color = '#FF3300'
    elseif percentage < 30 then
      color = '#FF6600'
    elseif percentage < 40 then
      color = '#FF9900'
    elseif percentage < 50 then
      color = '#FFCC00'
    elseif percentage < 60 then
      color = '#FFFF00'
    elseif percentage < 70 then
      color = '#FFFF33'
    elseif percentage < 80 then
      color = '#FFFF66'
    else
      color = '#FFFFFF'
    end

    text:set_text(msg)
    widget:set_fg(color)
  end,
  widget
)

return widget
