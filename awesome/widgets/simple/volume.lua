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
      val = 'X '..volume..'%'
    elseif volume >= 50 then
      val = '  '..volume..'%'
    elseif volume > 0 then
      val = '  '..volume..'%'
    else
      val = '  '..volume..'%'
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

function widget:update_widget(cmd)
  awful.spawn.easy_async(cmd, set_widget)
end

function widget:toggle()
  widget:update_widget('amixer -D pulse sset Master toggle')
end

function widget:inc_vol(delta)
  delta = delta or 5
  widget:update_widget('amixer -D pulse sset Master '..delta..'%+')
end

function widget:dec_vol(delta)
  delta = delta or 5
  widget:update_widget('amixer -D pulse sset Master '..delta..'%-')
end

function widget:set_exact_vol(value)
  value = value or 50
  widget:update_widget('amixer -D pulse sset Master '..value..'%')
end

widget:connect_signal('button::press', function(_,_,_,button)
  if (button == 1) then widget:toggle()
  elseif (button == 3) then
    -- awful.spawn('alacritty -t floating-alacritty -o window.opacity=1.0 -e pulsemixer')
    -- Nothing I do updates the widget, because the update/set line is ran
    -- before the spawned program closes. I want to run it only after the
    -- spawned program terminates. Please help! ):
    -- Weird
    awful.spawn('/home/lucas/.config/awesome/widgets/simple/pulsemixer+volume-update.sh')
  elseif (button == 4) then widget:inc_vol(2)
  elseif (button == 5) then widget:dec_vol(2) end
end)

return widget
