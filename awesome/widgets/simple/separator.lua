-- Original:
-- https://github.com/divineLush/awesomewm-dumb-widgets/blob/master/separator.lua
-------------------------------------------------
-- Separator widget
-------------------------------------------------

local wibox = require("wibox")

local widget = wibox.widget({
    widget = wibox.widget.separator,
    forced_width = 10,
    thickness = 0,
    color = "#84a0c6"
})

return widget
