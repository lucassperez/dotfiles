-- I don't even know what I am doing
local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
local watch = require('awful.widget.watch')

local text = wibox.widget({
    font = 'FontAwesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)

local function set_widget()
  if naughty.is_suspended() then
    color = '#be616e'
    icon  = ''
  else
    color = '#a4b98e'
    icon  = ''
  end
  widget:set_fg(color)
  text:set_text(icon)
end

set_widget()

function widget:toggle()
  naughty.toggle()
  set_widget()
end

function widget:suspend()
  naughty.suspend()
  set_widget()
end

function widget:resume()
  naughty.resume()
  set_widget()
end

widget:connect_signal('button::press', function(_,_,_,button)
  if (button) then widget:toggle() end
end)

return widget
