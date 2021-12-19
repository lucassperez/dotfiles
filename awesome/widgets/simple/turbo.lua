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
text:set_text('TURBO ')

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
  if naughty.suspended then return end

  naughty.destroy_all_notifications()

  if math.random(2) == 1 then
    phrase = widget:random_phrase()
  else
    phrase = widget:random_build_phrase()
  end
  phrase = phrase..' '..widget:random_verb()

  naughty.notify({
    title = phrase,
    ignore_suspend = false, -- this is not working, ffs
    timeout = 6,
  })
end

widget:connect_signal('button::press', function(_,_,_,button)
  if button == 1 then widget:send_turbo_notification() end
end)

return widget
