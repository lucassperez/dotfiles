local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')

local text = wibox.widget({
    font = 'Font Awesome Mono 12',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#00ff00')

local function set_widget()
  text:set_text('TURBO')
end

set_widget()

function widget:random_from_list(list)
  return list[math.random(#list)]
end

function widget:random_phrase()
  phrases = {
    'MAX TURBO',
    'ULTRA NITRO',
    'MEGA BLASTER',
    'HYPER BIONIC',
    'EXTREME HYPERPROCESSOR',
    'ULTIMATE COSMIC',
    'SUPER TRANSLUSCENT',
    'FINAL ROBOTIC',
    'INTERGALATIC POWERLIGHT',
    'NANO POWER CONVERTER',
    'SUBSPACE MOLECULE GENERATOR',
    'INTERDIMENSIONAL HYPERX',
    'POWER GENETIC TRANSPORTER'
  }
  return widget:random_from_list(phrases)
end

function widget:random_build_phrase()
  prefixes = {
    'MAX', 'TURBO', 'ULTRA', 'NITRO', 'MEGA', 'BLASTER', 'HYPER', 'BIONIC',
    'SPACE', 'EXTREME', 'ULTIMATE', 'COSMIC', 'SUPER', 'TRANSLUSCENT',
    'FINAL', 'ROBOTIC', 'INTERGALATIC', 'NANO', 'POWER', 'SUBSPACE',
    'INTERDIMENSIONAL',
    'MAX', 'TURBO', 'ULTRA', 'NITRO', 'MEGA',
    'MAX', 'TURBO', 'ULTRA', 'NITRO', 'MEGA',
  }
  suffixes ={
    'HYPERPROCESSOR', 'POWERLIGHT', 'POWER CONVERTER', 'MOLECULE GENERATOR',
    'HYPERX', 'GENETIC TRANSPORTER', 'ACCELERATOR', 'QUADRATIC ENGINES'
  }
  return widget:random_from_list(prefixes)..' '..widget:random_from_list(suffixes)
end

function widget:random_verb()
  verbs = {
    'ACTIVATED', 'STARTED', 'NEUTRALIZED', 'DESTROYED', 'INTERRUPTED',
    'ACCELERATED', 'HEATING UP', 'SHUTTING DOWN', 'DOWN', 'IGNITED',
    'TURNED ON', 'BOOTED SUCCESFULLY', 'RECOVERED', 'SENT TO INTERDIMENSIONAL RIFT',
    'TOOK OFF', 'LANDED'
  }
  return widget:random_from_list(verbs)
end

function widget:send_turbo_notification()
  -- os.execute('dunstctl close-all')

  if math.random(2) == 1 then
    phrase = widget:random_phrase()
  else
    phrase = widget:random_build_phrase()
  end
  phrase = phrase..' '..widget:random_verb()

  naughty.notify({
    title = phrase,
    ignore_suspend = true,
    timeout = 6,
  })
  -- os.execute('notify-send "'..phrase..'"')
end

widget:connect_signal('button::press', function(_,_,_,button)
  if button == 1 then widget:send_turbo_notification() end
end)

return widget
