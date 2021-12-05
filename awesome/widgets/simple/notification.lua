-- I don't even know what I am doing
-- local awful = require('awful')
-- local wibox = require('wibox')
-- local naughty = require('naughty')
-- local watch = require('awful.widget.watch')

-- local text = wibox.widget({
--     -- font = 'Anonymous Pro Bold 12',
--     font = 'Font Awesome 11',
--     widget = wibox.widget.textbox,
-- })

-- local widget = wibox.widget.background()
-- widget:set_widget(text)

-- local function set_widget()
--   awful.spawn.easy_async(
--   '',
--   function()
--     if naughty.suspended then
--       color = '#BE616E'
--       icon  = ''
--     else
--       color = '#A4B98E'
--       icon  = ''
--     end

--     widget:set_fg(color)
--     text:set_text(icon)
--   end
--   )
-- end

-- set_widget()

-- function widget:toggle()
--   naughty.suspended = not naughty.suspended
-- end

-- widget:connect_signal('button::press', function(_,_,_,button)
--   if (button) then widget:toggle() end
-- end)

-- return widget
