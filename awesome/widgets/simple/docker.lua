-- Dependencies:
-- docker

local wibox = require('wibox')
local watch = require('awful.widget.watch')
local naughty = require('naughty')
local config_home = os.getenv('XDG_CONFIG_DIR') or os.getenv('HOME') .. '/.config'

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#0db7ed')

-- TODO Find out why piping docker ps to wc -l doesn't work.
--      Maybe the pipe is not supported in watch.
watch('docker ps -q', 5, function(widget, stdout, stderr, exitreason, exitcode)
  -- gsub also returns how many times a substitution happened
  -- Basically counting how many new lines are present.
  -- Select gets only the nth value returned by the given
  -- function without allocating the memoty for the other values.
  local count = select(2, stdout:gsub('\n', ''))
  text:set_text('🐳 ' .. count)
end, widget)

widget:connect_signal('button::press', function(_, _, _, button)
  if button == 1 or button == 3 then
    local notif_text = ''
    local docker_response = io.popen('docker ps --format "{{.Names}} ({{.Status}})\n"')
    if docker_response == nil then return end

    local line
    while true do
      if docker_response then line = docker_response:read() end
      if not line then break end
      notif_text = notif_text .. '\n' .. line
    end

    docker_response:close()

    if notif_text == '' then notif_text = 'No containers running' end

    naughty.notify({
      title = 'Dockers',
      text = notif_text,
      icon = config_home .. '/awesome/widgets/simple/icons/docker-smaller.png',
      icon_size = 32,
    })
  end
end)

return widget
