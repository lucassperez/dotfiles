return {
  call = function()
    -- This just works with my own brightness, microphone, volume and
    -- screen temperature widgets
    require('widgets.simple.volume'):roundUpToNearestEvenNumberOrMultipleOf5()
    require('widgets.simple.microphone'):roundUpToNearestEvenNumberOrMultipleOf5()
    require('widgets.simple.brightness'):roundNearest5()
    require('widgets.simple.screen_temperature'):update_widget()
  end
}
