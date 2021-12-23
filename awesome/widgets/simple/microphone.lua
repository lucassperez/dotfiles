-- Original:
-- https://github.com/divineLush/dotfiles/blob/master/.config/awesome/widgets/mic.lua
-- Alterando pra mostrar o volume do microfone, e não apenas 0/1 pra desligado/ligado
-------------------------------------------------
-- Mic widget
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')

local text = wibox.widget({
    -- font = 'Anonymous Pro Bold 12',
    -- font = 'Hack 12',
    font = 'FontAwesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#d6ce6f')

local function set_widget()
  awful.spawn.easy_async(
  'amixer sget Capture',
  function(out)
    local val, is_on = string.match(out, 'Front Left.*%[(%d+)%%%].*%[(%w+)%]')

    if is_on == 'on' then
      val = ' '..val..'%'
    else
      val = ' '..val..'%'
    end

    text:set_text(val)
  end
  )
end

set_widget()

local function update_widget(cmd)
  awful.spawn.easy_async(cmd, set_widget)
end

function widget:toggle()
  update_widget('amixer sset Capture toggle')
end

function widget:inc_vol(delta)
  delta = delta or 5
  update_widget('amixer sset Capture '..delta..'%+')
end

function widget:dec_vol(delta)
  delta = delta or 5
  update_widget('amixer sset Capture '..delta..'%-')
end

function widget:set_exact_vol(value)
  value = value or 50
  update_widget('amixer sset Capture '..value..'%')
end

widget:connect_signal('button::press', function(_,_,_,button)
  if (button == 1) then widget:toggle()
  elseif (button == 4) then widget:inc_vol(5)
  elseif (button == 5) then widget:dec_vol(5) end
end)

return widget
