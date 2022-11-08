return {
  call = function()
    -- This just works with my own brightness, microphone and volume widgets
    require('widgets.simple.volume'):update_widget()
    require('widgets.simple.microphone'):update_widget()
    require('widgets.simple.brightness'):roundNearest5()
  end
}
