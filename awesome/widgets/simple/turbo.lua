local wibox = require('wibox')
local naughty = require('naughty')

local text = wibox.widget({
    font = 'FontAwesome Mono 11',
    widget = wibox.widget.textbox,
})

local widget = wibox.widget.background()
widget:set_widget(text)
widget:set_fg('#00ff00')
-- text:set_text('TURBO ')
text:set_text('ARMENGAÇÃO ')

local function random_from_list(list)
  return list[math.random(#list)]
end

local function random_phrase()
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
    'INTERDIMENSIONAL FIFINE',
    'POWER GENETIC TRANSPORTER'
  }
  return random_from_list(phrases)
end

local function random_build_phrase()
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
    'FIFINE', 'GENETIC TRANSPORTER', 'ACCELERATOR', 'QUADRATIC ENGINES'
  }
  return random_from_list(prefixes)..' '..random_from_list(suffixes)
end

local function random_verb()
  verbs = {
    'ACTIVATED', 'STARTED', 'NEUTRALIZED', 'DESTROYED', 'INTERRUPTED',
    'ACCELERATED', 'HEATING UP', 'SHUTTING DOWN', 'DOWN', 'IGNITED',
    'TURNED ON', 'BOOTED SUCCESFULLY', 'RECOVERED', 'SENT TO INTERDIMENSIONAL RIFT',
    'TOOK OFF', 'LANDED'
  }
  return random_from_list(verbs)
end

function widget:send_turbo_notification()
  require('widgets.simple.update_brightness_microphone_and_volume_icons').call()

  if naughty.suspended then return end

  naughty.destroy_all_notifications()

  if math.random(2) == 1 then
    phrase = random_phrase()
  else
    phrase = random_build_phrase()
  end
  phrase = phrase..' '..random_verb()

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
