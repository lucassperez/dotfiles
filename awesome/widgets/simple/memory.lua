local wibox = require('wibox')
local watch = require('awful.widget.watch')
local naughty = require('naughty')

local text = wibox.widget({
  font = 'FontAwesome 11',
  widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#de6347')

watch('free -h', 10, function(widget, stdout, stderr, exitreason, exitcode)
  local free_memory = stdout:match('Mem:%s*[%w,.]*%s*([%w,.]*)')

  -- file = io.open('/home/lucas/.config/awesome/widgets/simple/anota-lua', 'a')
  -- file:write(stdout..'\n')
  -- file:write(free_memory..'\n')
  -- file:write('--\n')
  -- file:close()

  text:set_text(free_memory)
end, widget)

-- local function right_pad(string, size, character)
--   character = character or ' '
--   local padded_string = string
--   while #padded_string < size do
--     padded_string = padded_string..character
--   end
--   return padded_string
-- end

widget:connect_signal('button::press', function(_, _, _, button)
  if button >= 4 then return end

  -- local processes = io.popen('ps axh -o cmd,%mem --sort=-%mem')
  local processes = io.popen('ps axhc -o cmd,%mem --sort=-%mem')
  if not processes then return end

  local free_memory = io.popen('free -h | grep "^Mem:"'):read():match('Mem:%s*[%w,]*%s*([%w,]*)')
  local n_most_memory_consuming = 15
  local message = ''

  -- I guess that if `n_most_memory_consuming` is higher than the number of
  -- processes running, this would eventually try to concatenate `nil` with
  -- some strings, raising an exception.
  -- This should never realistic happen, though.
  local i = 0
  while i <= n_most_memory_consuming do
    -- process, mem = processes:read():match('(.*)%s*(.*)')
    message = message .. (processes:read():gsub('Isolated Web Co', 'Firefox')) .. '\n'
    i = i + 1
  end
  message = message .. processes:read():gsub('Isolated Web Co', 'Firefox')

  processes:close()

  local notif_options = {
    title = n_most_memory_consuming .. ' maiores consumos de memória (' .. free_memory .. ')',
    text = message,
  }

  if button == 2 then
    -- set 0 for no timeout, default is 5
    notif_options.timeout = 60
    notif_options.bg = require('beautiful').my_red_notification_background or '#ca4444'
  end

  naughty.notify(notif_options)
end)

return widget
