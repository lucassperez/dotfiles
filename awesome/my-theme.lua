-------------------------------------
-- Slightly modified default theme --
-------------------------------------

local theme_assets = require('beautiful.theme_assets')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()

local theme = {}

local bgcolor    = '#008080'
local ibgcolor   = '#363636'
local ubgcolor   = '#8b1a38'
local textcolor  = '#f4f4f4'
local itextcolor = '#888888'

-- theme.font          = 'sans 8'
theme.font          = 'Hack Mono 8'

theme.bg_normal     = ibgcolor
theme.bg_focus      = bgcolor
theme.bg_urgent     = ubgcolor
theme.bg_minimize   = '#444444'
-- theme.bg_systray    = theme.bg_normal
theme.bg_systray    = '#000000'

theme.fg_normal     = '#aaaaaa'
theme.fg_focus      = textcolor
theme.fg_urgent     = textcolor
theme.fg_minimize   = textcolor

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(3)
theme.border_normal = ibgcolor
theme.border_focus  = bgcolor
theme.border_marked = ubgcolor

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
theme.hotkeys_modifiers_fg = '#c9c9c9'
theme.hotkeys_fg = '#b0b0b0'
-- Example:
-- theme.taglist_bg_focus = '#ff0000'
-- theme.tasklist_bg_normal = '#000000'
-- theme.tasklist_disable_icon = true
theme.tasklist_disable_task_name = true
theme.tasklist_bg_normal = '#000000'
-- theme.tasklist_bg_focus = ibgcolor
-- theme.tasklist_align = 'center'
theme.tasklist_bg_focus = '#000000'
-- theme.tasklist_plain_task_name = true -- is not working, why
theme.tasklist_align = 'left'
-- theme.tasklist_font = 'Hack Mono 10'
-- theme.tasklist_font_focus = 'Hack Mono Bold 10'

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, textcolor
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, textcolor
)
theme.taglist_font = 'Hack Mono 10'
theme.taglist_spacing = 2

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
-- theme.notification_bg = '#008080'
theme.notification_bg = '#222222'
theme.notification_fg = '#ffffff'
theme.notification_border_width = '4' -- this doesnt work
-- theme.notification_border_color = '#008080'
theme.notification_border_color = '#00ff00'
theme.notification_margin = 50
theme.notification_icon_size = 32

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path..'default/submenu.png'
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = '#cc0000'

-- Define the image to load
theme.titlebar_close_button_normal = themes_path..'default/titlebar/close_normal.png'
theme.titlebar_close_button_focus  = themes_path..'default/titlebar/close_focus.png'

theme.titlebar_minimize_button_normal = themes_path..'default/titlebar/minimize_normal.png'
theme.titlebar_minimize_button_focus  = themes_path..'default/titlebar/minimize_focus.png'

theme.titlebar_ontop_button_normal_inactive = themes_path..'default/titlebar/ontop_normal_inactive.png'
theme.titlebar_ontop_button_focus_inactive  = themes_path..'default/titlebar/ontop_focus_inactive.png'
theme.titlebar_ontop_button_normal_active = themes_path..'default/titlebar/ontop_normal_active.png'
theme.titlebar_ontop_button_focus_active  = themes_path..'default/titlebar/ontop_focus_active.png'

theme.titlebar_sticky_button_normal_inactive = themes_path..'default/titlebar/sticky_normal_inactive.png'
theme.titlebar_sticky_button_focus_inactive  = themes_path..'default/titlebar/sticky_focus_inactive.png'
theme.titlebar_sticky_button_normal_active = themes_path..'default/titlebar/sticky_normal_active.png'
theme.titlebar_sticky_button_focus_active  = themes_path..'default/titlebar/sticky_focus_active.png'

theme.titlebar_floating_button_normal_inactive = themes_path..'default/titlebar/floating_normal_inactive.png'
theme.titlebar_floating_button_focus_inactive  = themes_path..'default/titlebar/floating_focus_inactive.png'
theme.titlebar_floating_button_normal_active = themes_path..'default/titlebar/floating_normal_active.png'
theme.titlebar_floating_button_focus_active  = themes_path..'default/titlebar/floating_focus_active.png'

theme.titlebar_maximized_button_normal_inactive = themes_path..'default/titlebar/maximized_normal_inactive.png'
theme.titlebar_maximized_button_focus_inactive  = themes_path..'default/titlebar/maximized_focus_inactive.png'
theme.titlebar_maximized_button_normal_active = themes_path..'default/titlebar/maximized_normal_active.png'
theme.titlebar_maximized_button_focus_active  = themes_path..'default/titlebar/maximized_focus_active.png'

-- theme.wallpaper = themes_path..'default/background.png'
theme.wallpaper = '/home/lucas/Pictures/wallpapers/wall.jpg'

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path..'default/layouts/fairhw.png'
theme.layout_fairv = themes_path..'default/layouts/fairvw.png'
theme.layout_floating  = themes_path..'default/layouts/floatingw.png'
theme.layout_magnifier = themes_path..'default/layouts/magnifierw.png'
theme.layout_max = themes_path..'default/layouts/maxw.png'
theme.layout_fullscreen = themes_path..'default/layouts/fullscreenw.png'
theme.layout_tilebottom = themes_path..'default/layouts/tilebottomw.png'
theme.layout_tileleft   = themes_path..'default/layouts/tileleftw.png'
theme.layout_tile = themes_path..'default/layouts/tilew.png'
theme.layout_tiletop = themes_path..'default/layouts/tiletopw.png'
theme.layout_spiral  = themes_path..'default/layouts/spiralw.png'
theme.layout_dwindle = themes_path..'default/layouts/dwindlew.png'
theme.layout_cornernw = themes_path..'default/layouts/cornernww.png'
theme.layout_cornerne = themes_path..'default/layouts/cornernew.png'
theme.layout_cornersw = themes_path..'default/layouts/cornersww.png'
theme.layout_cornerse = themes_path..'default/layouts/cornersew.png'

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    -- theme.menu_height, theme.bg_focus, '#000000'
    theme.menu_height, '#000000', '#e6e6e6'
)
-- theme.awesome_icon = '/home/lucas/lua-icon/copy.png'

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
