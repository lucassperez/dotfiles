return {
  call = function()
    -- This just works with my own brightness, microphone, volume and
    -- screen temperature widgets
    require('widgets.simple.volume'):roundUpToNearestEvenNumberOrMultipleOf5()
    require('widgets.simple.microphone'):roundUpToNearestEvenNumberOrMultipleOf5()
    require('widgets.simple.brightness'):roundNearest5()
    -- I did not want to change the name of the file again
    -- since it is also used in .profile, but it also updates
    -- the screen_temperature and battery widgtets.
    require('widgets.simple.screen_temperature'):update_widget()
    require('widgets.simple.battery'):update_widget()
  end,
}
