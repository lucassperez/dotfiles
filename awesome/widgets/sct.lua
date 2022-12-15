-- Precisa instalar esse xsct
-- https://github.com/faf0/sct

-- Baseado nesse:
-- [2021-02-25 Thu]
-- @author: Phil Estival (pe [@t] 7d.nz)
-- https://github.com/flintforge/awesome-wm-widgets/blob/main/sct.lua

local awful = require('awful')
local wibox = require('wibox')

local function worker(user_args)
  -- Com mais de uma tela, isso aqui talvez não funcione por cause do ^$?
  -- local temperature = io.popen('xsct'):read():match('^Screen [0-9]+: temperature ~ ([0-9]+)$')
  local temperature = io.popen('xsct'):read():match('^Screen [0-9]+: temperature ~ ([0-9]+)')
  local default_temperature = 5250

  -- Ter essa variável "temperature" pra monitorar o estado não é muito bom,
  -- pois se eu alterar a temperatura da tela por algum meio que não é o widget,
  -- essa variável vai ficar desatualizada.

  local sct = wibox.widget {
    font   = 'FontAwesome 11',
    bg     = '#000000',
    widget = wibox.widget.textbox,
  }

  local function get_temperature()
     sct.markup = string.format(' %.1f', temperature / 1000)
  end

  get_temperature()

  sct:connect_signal(
    'button::press',
    function(_, _, _, button)
      if button == 5 then
        temperature = temperature - 250
      elseif button == 4 then
        temperature = temperature + 250
      elseif button == 1 or button == 2 or button == 3 then
        temperature = default_temperature
      end

      if temperature < 1000 then temperature = 1000
      elseif temperature > 10000 then temperature = 10000 end

      awful.spawn('xsct '..temperature, false)
      get_temperature()
    end
  )

  local function updateTemperature(tpr)
    if not tpr or tpr == 0 then return end

    temperature = temperature + tpr
    awful.spawn('xsct -d '..tpr, false)
    get_temperature()
  end

  local function setTemperature(tpr)
    tpr = tpr or default_temperature
    temperature = tpr
    awful.spawn('xsct '..tpr, false)
    get_temperature()
  end

  local Sct = {
    widget = sct,
    update = updateTemperature,
    set = setTemperature,
  }

  return Sct
end


local sct_widget = {}
return setmetatable( sct_widget, {
  __call = function(_, ...) return worker(...) end
})
