-- Original
-- https://github.com/divineLush/dotfiles/blob/master/.config/awesome/widgets/mic.lua
-- Alterando pra mostrar o volume do microfone, e não apenas 0/1 pra desligado/ligado
-------------------------------------------------
-- Mic widget
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')

local text = wibox.widget({
    font = 'Hack 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#d986c0')

local function set_widget()
  awful.spawn.easy_async(
  'amixer -D pulse sget Master',
  function(out)
    local volume, on_or_off = string.match(out, 'Front Left.*%[(%d+)%%%].*%[(%w+)%]')
    if not volume then
      volume, on_or_off = string.match(out, 'Mono: Playback.*%[(%d+)%%%].*%[(%w+)%]')
    end
    volume = tonumber(volume)

    if on_or_off == 'off' then
      val = 'X'..volume..'%'
    elseif volume >= 50 then
      val = ' '..volume..'%'
    elseif volume > 0 then
      val = ' '..volume..'%'
    else
      val = ' '..volume..'%'
    end

    -- file = io.open('/home/lucas/.config/awesome/widgets/anota-lua', 'a')
    -- file:write(out..'\n')
    -- file:write(volume..'\n')
    -- file:write(on_or_off..'\n')
    -- file:write(volume_number..'\n')
    -- file:write('--\n')
    -- file:close()

    text:set_text(val)
  end
  )
end

set_widget()

local function update_widget(cmd)
  awful.spawn.easy_async(cmd, set_widget)
end

function widget:toggle()
  update_widget('amixer -D pulse sset Master toggle')
end

function widget:inc_vol(delta)
  delta = delta or 5
  update_widget('amixer -D pulse sset Master '..delta..'%+')
end

function widget:dec_vol(delta)
  delta = delta or 5
  update_widget('amixer -D pulse sset Master '..delta..'%-')
end

function widget:set_exact_vol(value)
  value = value or 50
  update_widget('amixer -D pulse sset Master '..value..'%')
end

widget:connect_signal('button::press', function(_,_,_,button)
  if (button == 1) then widget:toggle()
  elseif (button == 4) then widget:inc_vol(5)
  elseif (button == 5) then widget:dec_vol(5) end
end)

return widget
