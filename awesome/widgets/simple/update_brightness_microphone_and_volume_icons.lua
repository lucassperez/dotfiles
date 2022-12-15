return {
  call = function()
    -- This just works with my own brightness, microphone and volume widgets
    require('widgets.simple.volume'):update_widget()
    require('widgets.simple.microphone'):update_widget()
    require('widgets.simple.brightness'):roundNearest5()
    -- Adding this, too.
    -- require('widgets.sct')().set()
    -- Except it doesn't work, probably because it
    -- is another instance of the widget with is
    -- own internal state.
  end
}
