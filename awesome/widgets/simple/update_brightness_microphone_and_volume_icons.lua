return {
  call = function()
    -- This just works with my own brightness, microphone, volume and
    -- screen temperature widgets
    require('widgets.simple.volume'):update_widget()
    require('widgets.simple.microphone'):update_widget()
    require('widgets.simple.brightness'):roundNearest5()
    require('widgets.simple.screen_temperature'):update_widget()
  end
}
