#!/bin/env lua

function random_from_list(list)
  return list[math.random(#list)]
end

function random_phrase()
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
    'POWER GENETIC TRANSPORTER',
  }
  return random_from_list(phrases)
end

function random_build_phrase()
  prefixes = {
    'MAX',
    'TURBO',
    'ULTRA',
    'NITRO',
    'MEGA',
    'BLASTER',
    'HYPER',
    'BIONIC',
    'SPACE',
    'EXTREME',
    'ULTIMATE',
    'COSMIC',
    'SUPER',
    'TRANSLUSCENT',
    'FINAL',
    'ROBOTIC',
    'INTERGALATIC',
    'NANO',
    'POWER',
    'SUBSPACE',
    'INTERDIMENSIONAL',
    'MAX',
    'TURBO',
    'ULTRA',
    'NITRO',
    'MEGA',
    'MAX',
    'TURBO',
    'ULTRA',
    'NITRO',
    'MEGA',
  }
  suffixes = {
    'HYPERPROCESSOR',
    'POWERLIGHT',
    'POWER CONVERTER',
    'MOLECULE GENERATOR',
    'HYPERX',
    'GENETIC TRANSPORTER',
    'ACCELERATOR',
    'QUADRATIC ENGINES',
  }
  return random_from_list(prefixes) .. ' ' .. random_from_list(suffixes)
end

function random_verb()
  verbs = {
    'ACTIVATED',
    'STARTED',
    'NEUTRALIZED',
    'DESTROYED',
    'INTERRUPTED',
    'ACCELERATED',
    'HEATING UP',
    'SHUTTING DOWN',
    'DOWN',
    'IGNITED',
    'TURNED ON',
    'BOOTED SUCCESFULLY',
    'RECOVERED',
    'SENT TO INTERDIMENSIONAL RIFT',
    'TOOK OFF',
    'LANDED',
  }
  return random_from_list(verbs)
end

function send_notification()
  os.execute('dunstctl close-all')

  if math.random(2) == 1 then
    phrase = random_phrase()
  else
    phrase = random_build_phrase()
  end
  phrase = phrase .. ' ' .. random_verb()

  os.execute('notify-send "' .. phrase .. '"')
end

function clicked()
  return os.getenv('BLOCK_BUTTON')
end

if clicked() then send_notification() end

print('TURBO')
