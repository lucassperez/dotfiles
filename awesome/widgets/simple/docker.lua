local wibox = require('wibox')
local watch = require('awful.widget.watch')
local naughty = require('naughty')

local text = wibox.widget({
    font = 'Hack 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#0db7ed')

watch(
  -- TODO Find out why piping docker ps to wc -l doesn't work.
  --      Maybe the pipe is not supported.
  'docker ps -q',
  5,
  function(widget, stdout, stderr, exitreason, exitcode)
    -- gsub also returns how many times a substitution happened
    local _, count = stdout:gsub('\n', '\n')
    text:set_text('🐳 '..count)
  end,
  widget
)

widget:connect_signal(
  'button::press',
  function(_, _, _, button)
    if button == 1 or button == 3 then
      local text = ''
      local docker_response = io.popen('docker ps --format "{{.Names}} ({{.RunningFor}})\n"')

      while true do
        line = docker_response:read()
        if not line then break end
        text = text..'\n'..line
      end

      if text == '' then text = 'No containers running' end

      naughty.notify({
        title = 'Dockers',
        text = text,
        icon = '/home/lucas/.config/awesome/widgets/simple/icons/docker-smaller.png',
        icon_size = 32,
      })
    end
  end
)

return widget
