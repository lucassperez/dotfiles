-- Original:
-- https://github.com/divineLush/dotfiles/blob/master/.config/awesome/widgets/mic.lua
-- Alterando pra mostrar o volume do microfone, e não apenas 0/1 pra desligado/ligado
-------------------------------------------------
-- Mic widget
-------------------------------------------------

-- Dependencies:
-- pactl

local awful = require('awful')
local watch = require('awful.widget.watch')
local wibox = require('wibox')

local config_home = os.getenv('XDG_CONFIG_DIR') or os.getenv('HOME') .. '/.config'

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)

local function calculate_widget_output(out)
  local volume = out:match('^Volume: front%-left: *%d+ */ *(%d+)%%')
  if volume == nil then volume = out:match('^Volume: mono: *%d+ */ *(%d+)%%') end

  volume = tostring(volume)

  local f = io.popen('pactl get-source-mute @DEFAULT_SOURCE@')
  if f == nil then return end

  local mute = f:read()
  if mute then mute = mute:match('^Mute: (%w+)$') end
  f:close()

  local val = ''

  widget:set_fg('#d6ce6f')

  if mute == nil then
    val = ' ? ' .. volume .. '%'
  elseif mute == 'no' then
    val = ' ' .. volume .. '%'
  else
    val = ' ' .. volume .. '%'
    widget:set_fg('#c6c6c6')
  end

  -- local file = io.open(config_home..'/awesome/widgets/simple/anota-lua', 'a')
  -- file:write(out..'\n')
  -- file:write(volume..'\n')
  -- file:write(mute..'\n')
  -- file:write('--\n')
  -- file:close()

  text:set_text(val)
end

local function draw_widget()
  awful.spawn.easy_async('pactl get-source-volume @DEFAULT_SOURCE@', calculate_widget_output)
end

draw_widget()
watch('pactl get-source-volume @DEFAULT_SOURCE@', 1, function(_, stdout) calculate_widget_output(stdout) end, widget)

-- Widget public interface --

function widget:update_widget(cmd)
  cmd = cmd or 'pactl get-source-volume @DEFAULT_SOURCE@'
  awful.spawn.easy_async(cmd, draw_widget)
end

function widget:toggle()
  widget:update_widget('pactl set-source-mute @DEFAULT_SOURCE@ toggle')
end

function widget:inc(delta)
  delta = delta or 5
  widget:update_widget('pactl set-source-volume @DEFAULT_SOURCE@ +' .. delta .. '% +' .. delta .. '%')
end

function widget:dec(delta)
  delta = delta or 5
  widget:update_widget('pactl set-source-volume @DEFAULT_SOURCE@ -' .. delta .. '% -' .. delta .. '%')
end

function widget:set(value)
  value = value or 50
  widget:update_widget('pactl set-source-volume @DEFAULT_SOURCE@  ' .. value .. '%')
end

widget:connect_signal('button::press', function(_, _, _, button)
  if (button == 1) then widget:toggle()
  elseif (button == 3) then
    -- Why doesn't this update the widget afterwards? ):
    -- awful.spawn('alacritty -t floating-alacritty -o window.opacity=1.0 -e pulsemixer')
    -- set_widget()

    -- Weird hack, just like in volume.lua
    awful.spawn(config_home .. '/awesome/widgets/simple/pulsemixer+volume-update.sh')
  elseif (button == 4) then widget:inc(2)
  elseif (button == 5) then widget:dec(2)
  elseif (button == 2) then
    awful.spawn(config_home .. '/awesome/widgets/simple/pavucontrol+volume-update.sh -t 4')
  end
end)

return widget
