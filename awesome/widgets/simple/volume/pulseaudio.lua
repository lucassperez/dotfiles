-- Dependencies:
-- pactl

local get_volume_command = 'pactl get-sink-volume @DEFAULT_SINK@'
local toggle_mute_command = 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

local function increase_volume_command(delta)
  return 'pactl set-sink-volume @DEFAULT_SINK@ +' .. delta .. '% +' .. delta .. '%'
end

local function decrease_volume_command(delta)
  return 'pactl set-sink-volume @DEFAULT_SINK@ -' .. delta .. '% -' .. delta .. '%'
end

local function set_volume_command(value)
  return 'pactl set-sink-volume @DEFAULT_SINK@ ' .. value .. '%'
end

local function parse_output(out)
  if out == '' then
    return nil, nil
  end

  local volume = out:match('^Volume: front%-left: *%d+ */ *(%d+)%%')
  if volume == nil then volume = out:match('^Volume: mono: *%d+ */ *(%d+)%%') end

  volume = tonumber(volume)

  local f = io.popen('pactl get-sink-mute @DEFAULT_SINK@')
  if f == nil then
    return volume, nil
  end

  local mute = f:read()
  if mute then mute = mute:match('^Mute: (%w+)$') end
  f:close()

  local is_muted

  if mute == nil then
    is_muted = nil
  elseif mute == 'yes' then
    is_muted = true
  else
    is_muted = false
  end

  return volume, is_muted
end

return {
  get_volume_command = get_volume_command,
  toggle_mute_command = toggle_mute_command,
  increase_volume_command = increase_volume_command,
  decrease_volume_command = decrease_volume_command,
  set_volume_command = set_volume_command,
  parse_output = parse_output,
}
