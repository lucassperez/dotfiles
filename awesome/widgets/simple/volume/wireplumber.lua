-- Dependencies:
-- wpctl

local get_volume_command = 'wpctl get-volume @DEFAULT_SINK@'
local toggle_mute_command = 'wpctl set-mute @DEFAULT_SINK@ toggle'

local function increase_volume_command(delta)
  return 'wpctl set-volume @DEFAULT_SINK@ ' .. delta .. '%+'
end

local function decrease_volume_command(delta)
  return 'wpctl set-volume @DEFAULT_SINK@ ' .. delta .. '%-'
end

local function set_volume_command(value)
  return 'wpctl set-volume @DEFAULT_SINK@ ' .. value .. '%'
end

local function parse_output(out)
  if out == '' then
    return nil, nil
  end

  local volume, is_muted = out:gsub('\n', ''):match('^Volume: ([%d.]+) ?(.*)')

  -- When volume is 0.58, this returns 57, why though?
  -- Even though math.floor(58.0) returns 58 correctly.
  -- What!
  -- volume = math.floor(volume * 100)
  -- Apparently also happens with other numbers, like 113/114 and 115/116.

  volume = volume:gsub('%.', '')
  volume = tonumber(volume)

  is_muted = is_muted == '[MUTED]'

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
