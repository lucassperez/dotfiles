-- Dependencies:
-- pactl

local get_volume_command = 'pactl get-source-volume @DEFAULT_SOURCE@'
local toggle_mute_command = 'pactl set-source-mute @DEFAULT_SOURCE@ toggle'

local function increase_volume_command(delta)
  return 'pactl set-source-volume @DEFAULT_SOURCE@ +' .. delta .. '% +' .. delta .. '%'
end

local function decrease_volume_command(delta)
  return 'pactl set-source-volume @DEFAULT_SOURCE@ -' .. delta .. '% -' .. delta .. '%'
end

local function set_volume_command(value)
  return 'pactl set-source-volume @DEFAULT_SOURCE@ ' .. value .. '%'
end

local function parse_output(out)
  if out == '' then
    return nil, nil
  end

  local volume = out:match('^Volume: front%-left: *%d+ */ *(%d+)%%')
  if volume == nil then volume = out:match('^Volume: mono: *%d+ */ *(%d+)%%') end

  volume = tonumber(volume)

  local f = io.popen('pactl get-source-mute @DEFAULT_SOURCE@')
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
