#!/bin/env lua

phrases = {
  '"MAX TURBO"',
  '"ULTRA NITRO"',
  '"MEGA BLASTER"',
  '"HYPER BIONIC"',
}


-- if os.getenv('BLOCK_BUTTON') then
  os.execute('notify-send '..phrases[math.random(#phrases)])
-- end

print('TURBO')
