-- Original:
-- https://github.com/divineLush/dotfiles/blob/master/.config/awesome/widgets/mic.lua
-- Alterando pra mostrar o volume do microfone, e não apenas 0/1 pra desligado/ligado
-------------------------------------------------
-- Mic widget
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')

local text = wibox.widget({
    -- font = 'Anonymous Pro Bold 12',
    font = 'Font Awesome 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#D6CE6F')

local function set_widget()
  awful.spawn.easy_async(
  'amixer',
  function(out)
    local is_on = string.find(out, 'Capture.*%[on%]') ~= nil
    local val = string.match(out, 'Capture %w* %[(%d+)%%%]')
    -- file = io.open('/home/lucas/.config/awesome/widgets/anota-lua', 'a')
    -- file:write(out)
    -- file:write('\nnumber = '..number..'\n')
    -- file:write('--\n')
    -- file:close()


    if is_on then
      val = ' '..val..'%'
    else
      val = ' '..val..'%'
    end

    text:set_text(val)
  end
  )
end

set_widget()

local function update_widget(cmd)
  awful.spawn.easy_async(cmd, set_widget)
end

function widget:toggle()
  update_widget('amixer sset Capture toggle')
end

function widget:inc_vol(delta)
  delta = delta or 5
  update_widget('amixer sset Capture '..delta..'%+')
end

function widget:dec_vol(delta)
  delta = delta or 5
  update_widget('amixer sset Capture '..delta..'%-')
end

widget:connect_signal('button::press', function(_,_,_,button)
  if (button == 1) then widget:toggle()
  elseif (button == 4) then widget:inc_vol(5)
  elseif (button == 5) then widget:dec_vol(5) end
end)

return widget
