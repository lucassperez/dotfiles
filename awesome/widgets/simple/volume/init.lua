-- Original
-- https://github.com/divineLush/dotfiles/blob/master/.config/awesome/widgets/mic.lua
-- Alterando pra mostrar o volume do microfone, e não apenas 0/1 pra desligado/ligado
-------------------------------------------------
-- Mic widget
-------------------------------------------------

-- Dependencies:
-- pactl
-- or
-- wpctl

local awful = require('awful')
local watch = require('awful.widget.watch')
local wibox = require('wibox')

-- The implementation should be a table that has the required fields being used
-- in this file:
-- {
--   get_volume_command      [string]
--   toggle_mute_command     [string]
--   increase_volume_command [function(number|string) string]
--   decrease_volume_command [function(number|string) string]
--   set_volume_command      [function(number|string) string]
--   parse_output            [function(string) (number|nil, boolean|nil)]
-- }
-- local implementation = require('widgets.simple.volume.pulseaudio')
local implementation = require('widgets.simple.volume.wireplumber')

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)

local function calculate_widget_output(stdout)
  local volume, is_muted = implementation.parse_output(stdout)

  if volume == 0 or is_muted then
    widget:set_fg('#c6c6c6')
  else
    widget:set_fg('#d986c0')
  end

  local val = ''

  if is_muted == nil then
    val = ' ? ' .. tostring(volume) .. '%'
  elseif is_muted then
    val = 'X ' .. tostring(volume) .. '%'
  else
    if volume >= 50 then
      val = '  ' .. tostring(volume) .. '%'
    elseif volume > 0 then
      val = '  ' .. tostring(volume) .. '%'
    else
      val = '  ' .. tostring(volume) .. '%'
    end
  end

  -- local config_home = os.getenv('XDG_CONFIG_DIR') or (os.getenv('HOME') .. '/.config')
  -- local file = io.open(config_home..'/awesome/widgets/simple/anota-lua', 'a')
  -- file:write('   out: '..out..'\n')
  -- file:write('volume: '..volume..'\n')
  -- file:write('--\n')
  -- file:close()

  text:set_text(val)
end

local function draw_widget()
  awful.spawn.easy_async(implementation.get_volume_command, calculate_widget_output)
end

draw_widget()

watch(implementation.get_volume_command, 1, function(_, stdout)
  calculate_widget_output(stdout)
end, widget)

-- Widget public interface --

function widget:update_widget(cmd)
  cmd = cmd or implementation.get_volume_command
  awful.spawn.easy_async(cmd, draw_widget)
end

function widget:toggle()
  widget:update_widget(implementation.toggle_mute_command)
end

function widget:inc(delta)
  delta = delta or 5
  widget:update_widget(implementation.increase_volume_command(delta))
end

function widget:dec(delta)
  delta = delta or 5
  widget:update_widget(implementation.decrease_volume_command(delta))
end

function widget:set(value)
  value = value or 50
  widget:update_widget(implementation.set_volume_command(value))
end

function widget:roundUpToNearestEvenNumberOrMultipleOf5()
  -- TODO don't use io.popen?
  local f = io.popen(implementation.get_volume_command)
  if f == nil then return end

  local output = f:read()
  f:close()
  local volume = implementation.parse_output(output)
  if volume == nil then return end

  if volume % 5 == 0 then return end

  local rest = volume % 10
  if rest >= 7.5 then
    -- volume = (volume//10 * 10)
    volume = math.floor(volume / 10) * 10 + 10
  elseif rest >= 2.5 then
    volume = math.floor(volume / 10) * 10 + 5
  else
    volume = math.floor(volume / 10) * 10
  end

  widget:set(volume)
end

widget:connect_signal('button::press', function(_, _, _, button)
  if button == 1 then
    widget:toggle()
  elseif button == 3 then
    -- TODO Git awesome has raise_or_spawn. One day maybe I can use it.
    awful.spawn('alacritty -t floating-alacritty -o window.opacity=1.0 -e pulsemixer')
  elseif button == 4 then
    widget:inc(2)
  elseif button == 5 then
    widget:dec(2)
  elseif button == 2 then
    awful.spawn('pavucontrol -t 3')
  end
end)

return widget
