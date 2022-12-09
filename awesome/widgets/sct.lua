-- Precisa instalar esse xsct
-- https://github.com/faf0/sct

-- Baseado nesse:
-- [2021-02-25 Thu]
-- @author: Phil Estival (pe [@t] 7d.nz)
-- https://github.com/flintforge/awesome-wm-widgets/blob/main/sct.lua

local awful = require('awful')
local spawn = require('awful.spawn')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')

local function worker(user_args)
  local temperature = io.popen('xsct'):read():match('^Screen [0-9]+: temperature ~ ([0-9]+)$')

  local sct = wibox.widget {
    font   = 'FontAwesome 11',
    bg     = '#000000',
    widget = wibox.widget.textbox,
  }

  local function get_temperature()
     sct.markup = string.format(' %.1f', temperature / 1000)
  end

  get_temperature()

  local update_graphic = function(widget, stdout, _, _, _)
    widget.colors = { colors.B }
  end

  sct:connect_signal(
    'button::press',
    function(_, _, _, button)
      if button == 5 then
        temperature = temperature - 250
      elseif button == 4 then
        temperature = temperature + 250
      elseif button == 1 or button == 2 or button == 3 then
        temperature = 6500
      end

      if temperature < 1000 then temperature = 1000
      elseif temperature > 10000 then temperature = 10000 end

      awful.spawn('xsct '..temperature, false)
      get_temperature()
    end
  )

  local function updateTemperature(tpr)
    temperature = temperature + tpr
    awful.spawn('xsct ' .. temperature, false)
    get_temperature()
  end

  local Sct = {
    widget = sct,
    update = updateTemperature
  }

  return Sct
end


local sct_widget = {}
return setmetatable( sct_widget, {
  __call = function(_, ...) return worker(...) end
})
