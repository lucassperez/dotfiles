local wibox = require('wibox')
local watch = require('awful.widget.watch')
local naughty = require('naughty')

local text = wibox.widget({
    font = 'Font Awesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#de6347')

watch(
  'free -h',
  10,
  function(widget, stdout, stderr, exitreason, exitcode)
    local free_memory = stdout:match('Mem:%s*[%w,]*%s*([%w,]*)')
    text:set_text(free_memory)
  end,
  widget
)

function right_pad(string, size, character)
  character = character or ' '
  padded_string = string
  while #padded_string < size do
    padded_string = padded_string..character
  end
  return padded_string
end

widget:connect_signal(
  'button::press',
  function(_, _, _, button)
    local processes = io.popen('ps axh -o cmd,%mem --sort=-%mem')
    local n_most_memory_consuming = 15
    local message = ''

    -- I guess that if `n_most_memory_consuming` is higher than the number of
    -- processes running, this would eventually try to concatenate `nil` with
    -- some strings, raising an exception.
    -- This should never realistic happen, though.
    if button == 1 or button == 3 then
      for i = 1, (n_most_memory_consuming - 1) do
        process, mem = processes:read():match('(.*)%s*(.*)')
        message = message..processes:read()..'\n'
      end
      message = message..processes:read()
    end

    naughty.notify({
      title = n_most_memory_consuming..' maiores consumos de memória',
      text = message,
    })
  end
)

return widget
