-- Original
-- https://github.com/divineLush/dotfiles/blob/master/.config/awesome/widgets/mic.lua
-- Alterando pra mostrar o volume do microfone, e não apenas 0/1 pra desligado/ligado
-------------------------------------------------
-- Mic widget
-------------------------------------------------

-- Dependencies:
-- pactl

local awful = require('awful')
local wibox = require('wibox')
local config_home = os.getenv('XDG_CONFIG_DIR') or os.getenv('HOME') .. '/.config'

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#d986c0')

local function set_widget()
  awful.spawn.easy_async(
    'pactl get-sink-volume @DEFAULT_SINK@',
    function(out)
      local volume = out:match('^Volume: front%-left: *%d+ */ *(%d+)%%')
      if volume == nil then volume = out:match('^Volume: mono: *%d+ */ *(%d+)%%') end

      volume = tostring(volume)

      local f = io.popen('pactl get-sink-mute @DEFAULT_SINK@')
      if f == nil then return end

      local mute = f:read()
      if mute then mute = mute:match('^Mute: (%w+)$') end
      f:close()

      local val = ''

      if mute == nil then
        val = ' ? ' .. volume .. '%'
      elseif mute == 'yes' then
        val = 'X ' .. volume .. '%'
      else
        volume = tonumber(volume)
        if volume >= 50 then
          val = '  ' .. volume .. '%'
        elseif volume > 0 then
          val = '  ' .. volume .. '%'
        else
          val = '  ' .. volume .. '%'
        end
      end

      -- local file = io.open(config_home..'/awesome/widgets/simple/anota-lua', 'a')
      -- file:write(out..'\n')
      -- file:write(volume..'\n')
      -- file:write(on_or_off..'\n')
      -- file:write('--\n')
      -- file:close()

      text:set_text(val)
    end
  )
end

set_widget()

function widget:update_widget(cmd)
  cmd = cmd or 'pactl get-sink-volume @DEFAULT_SINK@'
  awful.spawn.easy_async(cmd, set_widget)
end

function widget:toggle()
  widget:update_widget('pactl set-sink-mute @DEFAULT_SINK@ toggle')
end

function widget:inc(delta)
  delta = delta or 5
  widget:update_widget('pactl set-sink-volume @DEFAULT_SINK@ +' .. delta .. '% +' .. delta .. '%')
end

function widget:dec(delta)
  delta = delta or 5
  widget:update_widget('pactl set-sink-volume @DEFAULT_SINK@ -' .. delta .. '% -' .. delta .. '%')
end

function widget:set(value)
  value = value or 50
  widget:update_widget('pactl set-sink-volume @DEFAULT_SINK@ ' .. value .. '%')
end

widget:connect_signal('button::press', function(_, _, _, button)
  if (button == 1) then widget:toggle()
  elseif (button == 3) then
    -- awful.spawn('alacritty -t floating-alacritty -o window.opacity=1.0 -e pulsemixer')
    -- Nothing I do updates the widget, because the update/set line is ran
    -- before the spawned program closes. I want to run it only after the
    -- spawned program terminates. Please help! ):
    -- Weird
    awful.spawn(config_home .. '/awesome/widgets/simple/pulsemixer+volume-update.sh')
  elseif (button == 4) then widget:inc(2)
  elseif (button == 5) then widget:dec(2)
  elseif (button == 2) then
    awful.spawn(config_home .. '/awesome/widgets/simple/pavucontrol+volume-update.sh -t 3')
  end
end)

return widget
