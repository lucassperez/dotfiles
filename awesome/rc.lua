-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')

-- Widget and layout library
local wibox = require('wibox')

-- Theme handling library
local beautiful = require('beautiful')

-- Notification library
local naughty = require('naughty')
-- Default timeout seems to be 5 seconds.
-- I'm increasing it quite a bit, to 15 seconds.
-- I hope it is not too much.
naughty.config.defaults.timeout = 15

local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')
-- hotkeys_popup.new{modifiers_fg='#00ff00'}
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require('awful.hotkeys_popup.keys')

-- Load Debian menu entries
-- local debian = require('debian.menu')
-- local has_fdo, freedesktop = pcall(require, 'freedesktop')

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = 'Oops, there were errors during startup!',
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal('debug::error', function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = 'Oops, an error happened!',
      text = tostring(err),
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. 'default/theme.lua')
beautiful.init(gears.filesystem.get_configuration_dir() .. 'my-theme.lua')

-- This is used later as the default terminal and editor to run.
local terminal = 'alacritty'
local terminal_tmux = 'alacritty -e tmux'
local floating_terminal = 'alacritty -t floating-alacritty -o window.opacity=1.0'
local floating_terminal_tmux = 'alacritty -t floating-alacritty -o window.opacity=1.0 -e tmux'

-- Even though my EDITOR env is set to nvim, this does not always work
-- editor = os.getenv('EDITOR') or 'editor'
local editor = 'nvim'
local editor_cmd = terminal .. ' -e ' .. editor
local browser = 'firefox'

local home = os.getenv('HOME')
local config_home = os.getenv('XDG_CONFIG_HOME') or home .. '/.config'
local scripts_dir = home .. '/scripts'

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = 'Mod4'
local control = 'Control'
local shift = 'Shift'

-- My custom layout
-- It does not really work with multi monitors yet
local limited_tile = require('limited-tile')
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.left,
  awful.layout.suit.fair,
  -- awful.layout.suit.max, -- I made mod + m toggle max layout instead of maximize
  -- awful.layout.suit.magnifier, -- magnifier is so weird
  -- awful.layout.suit.floating, -- Control + Super + Space toggle floating in focused client
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,

  -- Two reasons to add the max layout here:
  -- 1. When I toggled it with my mod + m key, it started to simply appear on the list anyways
  -- 2. I can now go to this layout with the mouse
  limited_tile,
  awful.layout.suit.max,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
  {
    'Hotkeys',
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
  },
  { 'Manual', floating_terminal .. ' -e man awesome' },
  { 'Edit Config', editor_cmd .. ' ' .. awesome.conffile },
  { 'Restart', awesome.restart },
  {
    'Quit',
    function()
      awesome.quit()
    end,
  },
  {
    'Reboot',
    function()
      awful.spawn.with_shell('reboot')
    end,
  },
  {
    'Power Off',
    function()
      awful.spawn.with_shell('shutdown now')
    end,
  },
}

local menu_awesome = { 'Awesome', myawesomemenu, beautiful.awesome_icon }

local mymainmenu = awful.menu({
  items = {
    menu_awesome,
    { '&Terminal', terminal },
    { '&Browser', browser },
    { '&Campo Minado', 'gnome-mines' },
    { '&Discord', 'discord' },
    { '&Lock Screen', 'slock' },
  },
})

-- local menu_terminal = { 'open terminal', terminal }
-- if has_fdo then
--   mymainmenu = freedesktop.menu.build({
--     before = { menu_awesome },
--     after =  { menu_terminal }
--   })
-- else
--   mymainmenu = awful.menu({
--     items = {
--       menu_awesome,
--       { 'Debian', debian.menu.Debian_menu.Debian },
--       menu_terminal,
--     }
--   })
-- end

local mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu,
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a wibox for each screen and add it
-- local taglist_buttons = gears.table.join(
--   awful.button({}, 1, function(t) t:view_only() end),
--   awful.button(
--   { modkey }, 1,
--   function(t) if client.focus then client.focus:move_to_tag(t) end end),
--
--   awful.button({}, 3, awful.tag.viewtoggle),
--   awful.button(
--   { modkey }, 3,
--   function(t) if client.focus then client.focus:toggle_tag(t) end end),
--
--   awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
--   awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
-- )

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal('request::activate', 'tasklist', { raise = true })
    end
  end),
  awful.button({}, 2, function(c)
    c.minimized = not c.minimized
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == 'function' then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

local separator_widget = require('widgets.simple.separator')
local turbo_widget = require('widgets.simple.turbo')
-- local date_widget = require('widgets.simple.date')
-- local clock_widget = require('widgets.simple.clock')
local datetime_widget = require('widgets.simple.datetime')
local battery_widget = require('widgets.simple.battery')
local volume_widget = require('widgets.simple.volume')
local microphone_widget = require('widgets.simple.microphone')
local bright_widget = require('widgets.simple.brightness')
local screen_temperature = require('widgets.simple.screen_temperature')
local memory_widget = require('widgets.simple.memory')
local notification_widget = require('widgets.simple.notification')
local docker_widget = require('widgets.simple.docker')

local function conditional_turtle_cpu_widget()
  if os.getenv('AWESOMEWM_USE_TURTLE_CPU_WIDGET') ~= nil then
    -- I wanted to make this fuction return multiple values,
    -- the turtle widget and the separator, but it did not seem to work
    return require('widgets.cpu.turtle-widget')()
  end
end

local function conditional_turtle_cpu_separator_widget()
  if os.getenv('AWESOMEWM_USE_TURTLE_CPU_WIDGET') ~= nil then
    -- so I created this silly one
    return separator_widget
  end
end

-- require('awesomewm-vim-tmux-navigator')({
--   left  = {'h'},
--   down  = {'j'},
--   up    = {'k'},
--   right = {'l'},
--   mod = 'Mod4',
--   mod_keysym = 'Super_L',
-- })

local toggleable_layouts_by_key = {
  max = awful.layout.suit.max,
  limited_tile = limited_tile,
}
local last_layout_cache = {}

local function toggleLayout(cache_key)
  local actual_layout = awful.screen.focused().selected_tag.layout
  local target_layout = toggleable_layouts_by_key[cache_key]
  if not target_layout then return end

  local cached_layout = last_layout_cache[cache_key]

  if actual_layout ~= target_layout then
    -- Only update cache if actual layout is not
    -- max nor the limited_tile
    if actual_layout ~= toggleable_layouts_by_key.max and actual_layout ~= toggleable_layouts_by_key.limited_tile then
      last_layout_cache[cache_key] = actual_layout
    end

    awful.layout.set(target_layout)
  elseif cached_layout then
    awful.layout.set(cached_layout)
  else -- Fallback
    awful.layout.set(awful.layout.layouts[1])
  end
end

local charitable = require('charitable')
-- Create tags and taglist
local taglist_buttons = gears.table.join(
  -- Toggle tags with both right click and scroll click
  awful.button({}, 1, function(t)
    charitable.select_tag(t, awful.screen.focused())
  end),
  awful.button({}, 2, function(t)
    charitable.toggle_tag(t, awful.screen.focused())
  end),
  awful.button({}, 3, function(t)
    charitable.toggle_tag(t, awful.screen.focused())
  end),
  -- Also toggle tags with all mouse buttons when holding control
  awful.button({ control }, 1, function(t)
    charitable.toggle_tag(t, awful.screen.focused())
  end),
  awful.button({ control }, 2, function(t)
    charitable.toggle_tag(t, awful.screen.focused())
  end),
  awful.button({ control }, 3, function(t)
    charitable.toggle_tag(t, awful.screen.focused())
  end)
)
local tags = charitable.create_tags({ '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' }, {
  awful.layout.layouts[1],
  awful.layout.layouts[1],
  awful.layout.layouts[1],
  awful.layout.layouts[1],
  awful.layout.layouts[1],
  awful.layout.layouts[1],
  awful.layout.layouts[1],
  awful.layout.layouts[1],
  awful.layout.suit.tile.bottom,
  awful.layout.layouts[1],
})
awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  -- All tags
  -- awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' }, s, awful.layout.layouts[1])
  -- Show an unselected tag when a screen is connected
  for i = 1, #tags do
    if not tags[i].selected then
      tags[i].screen = s
      tags[i]:view_only()
      break
    end
  end
  -- Create a special scratch tag for double buffering
  s.scratch = awful.tag.add('scratch-' .. s.index, {})
  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
    source = function(screen, args)
      return tags
    end,
  })

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  -- s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox = require('widgets.my-layout-box')(s, { delay_show = -1 })
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 2, function()
      toggleLayout('max')
    end),
    awful.button({ control }, 2, function()
      toggleLayout('limited_tile')
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  ))

  -- Create a taglist widget
  -- s.mytaglist = awful.widget.taglist({
  --   screen  = s,
  --   filter  = awful.widget.taglist.filter.all,
  --   buttons = taglist_buttons
  -- })

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
  })

  -- Create the wibox
  -- Top bar widgets
  s.mywibox = awful.wibar({
    position = 'top',
    screen = s,
    height = 21, -- dmenu has this height hardcoded too. Maybe I should make a "topbar height" variable
    bg = '#000000',
  })

  -- Add widgets to the wibox
  s.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    {
      layout = wibox.layout.fixed.horizontal,
      s.mytasklist,
    },
    -- s.mytasklist,
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      docker_widget,
      separator_widget,
      notification_widget,
      separator_widget,
      memory_widget,
      separator_widget,
      conditional_turtle_cpu_widget(),
      conditional_turtle_cpu_separator_widget(),
      screen_temperature,
      separator_widget,
      bright_widget,
      separator_widget,
      microphone_widget,
      separator_widget,
      volume_widget,
      separator_widget,
      battery_widget,
      -- separator_widget, date_widget,
      -- separator_widget, clock_widget,
      separator_widget,
      datetime_widget,
      -- separator_widget, turbo_widget,
      turbo_widget,
      -- mykeyboardlayout,
      wibox.widget.systray(),
      s.mylayoutbox,
    },
  })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({}, 3, function()
    mymainmenu:toggle()
  end)
  -- why
  -- awful.button({}, 4, awful.tag.viewnext),
  -- awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
  -- 122 XF86AudioLowerVolume
  -- 37  Control_L
  -- 133 Super_L
  -- 179 XF86Tools
  -- 122 XF86AudioLowerVolume
  -- 123 XF86AudioRaiseVolume
  -- 121 XF86AudioMute
  -- 174 XF86AudioStop
  -- 173 XF86AudioPrev
  -- 172 XF86AudioPlay
  -- 171 XF86AudioNext
  -- 163 XF86Mail
  -- 180 XF86HomePage
  -- 148 XF86Calculator
  -- 198 XF86AudioMicMute

  awful.key({ modkey }, 'c', function()
    awful.spawn(scripts_dir .. '/monitors-dmenu.sh')
  end, { group = 'System controls', description = 'choose second monitor position and/or reset wallpaper' }),
  -- awful.key({ modkey }, 'y',
  --           function() awful.spawn(scripts_dir..'/dmenu/copyq.sh') end,
  --           { group = 'System controls', description = 'Copyq dmenu script', }),
  -- only works with dmenu as launcher, but setting the CM_LAUNCHER inline is
  -- not working, don't know why ):
  -- awful.key({ modkey }, 'y', function()
  --   awful.spawn('clipmenu -i -h 21 -p "Clipboard" -sb "#008080" -nb "#000000"')
  -- end, { group = 'System controls', description = 'Clipmenu' }),
  awful.key({ modkey }, 'y', function()
    awful.spawn('clipmenu -i')
  end, { group = 'System controls', description = 'Clipmenu clipboard manager' }),
  awful.key({ modkey, shift }, 't', function()
    awful.spawn(scripts_dir .. '/toggle-touchpad.sh')
  end, { group = 'System controls', description = 'Touchpad' }),

  -- Volume control
  awful.key({ modkey }, ',', function()
    volume_widget:dec(2)
  end, { group = 'System controls', description = 'decrease volume' }),
  awful.key({ modkey }, '.', function()
    volume_widget:inc(2)
  end, { group = 'System controls', description = 'increase volume' }),
  awful.key({ modkey }, '/', function()
    volume_widget:toggle()
  end, { group = 'System controls', description = 'toggle mute volume' }),
  awful.key({ modkey }, ';', function()
    volume_widget:toggle()
  end, { group = 'System controls', description = 'toggle mute volume' }),
  awful.key({}, 'XF86AudioRaiseVolume', function()
    volume_widget:inc(5)
  end),
  awful.key({}, 'XF86AudioLowerVolume', function()
    volume_widget:dec(5)
  end),
  awful.key({}, 'XF86AudioMute', function()
    volume_widget:toggle()
  end),

  -- Microphone control
  awful.key({ modkey, control }, ',', function()
    microphone_widget:dec(2)
  end, { group = 'System controls', description = 'decrease microphone volume' }),
  awful.key({ modkey, control }, '.', function()
    microphone_widget:inc(2)
  end, { group = 'System controls', description = 'increase microphone volume' }),
  awful.key({ modkey, control }, '/', function()
    microphone_widget:toggle()
  end, { group = 'System controls', description = 'toggle mute microphone' }),
  awful.key({ modkey, shift }, '/', function()
    microphone_widget:toggle()
  end, { group = 'System controls', description = 'toggle mute microphone' }),
  awful.key({ modkey, control }, ';', function()
    microphone_widget:toggle()
  end, { group = 'System controls', description = 'toggle mute microphone' }),
  awful.key({ control }, 'XF86AudioRaiseVolume', function()
    microphone_widget:inc(5)
  end),
  awful.key({ control }, 'XF86AudioLowerVolume', function()
    microphone_widget:dec(5)
  end),
  awful.key({ control }, 'XF86AudioMute', function()
    microphone_widget:toggle()
  end),
  awful.key({}, 'XF86AudioMicMute', function()
    microphone_widget:toggle()
  end),

  awful.key({ modkey, control, shift }, '/', function()
    -- awful.spawn('alacritty -t floating-alacritty -o window.opacity=1.0 -e pulsemixer')
    awful.spawn(config_home .. '/awesome/widgets/simple/pulsemixer+volume-update.sh')
  end, { group = 'System controls', description = 'open pulsemixer' }),
  awful.key({ modkey, control, shift }, ';', function()
    -- awful.spawn('alacritty -t floating-alacritty -o window.opacity=1.0 -e pulsemixer')
    awful.spawn(config_home .. '/awesome/widgets/simple/pulsemixer+volume-update.sh')
  end, { group = 'System controls', description = 'open pulsemixer' }),

  -- Brightness control
  awful.key({ modkey }, '[', function()
    bright_widget:inc(2.5)
  end, { group = 'System controls', description = 'increase brightness' }),
  awful.key({ modkey }, ']', function()
    bright_widget:dec(2.5)
  end, { group = 'System controls', description = 'decrease brightness' }),
  awful.key({ modkey, shift }, '[', function()
    awful.spawn(scripts_dir .. '/dmenu/backlight.sh')
  end, { group = 'System controls', description = 'Ask for a brightness' }),
  awful.key({ modkey, shift }, ']', function()
    awful.spawn(scripts_dir .. '/dmenu/backlight.sh')
  end, { group = 'System controls', description = 'Ask for a brightness' }),
  awful.key({}, 'XF86MonBrightnessUp', function()
    bright_widget:inc(5)
  end),
  awful.key({}, 'XF86MonBrightnessDown', function()
    bright_widget:dec(5)
  end),

  -- Screen temperature control
  awful.key({ modkey, control }, '[', function()
    screen_temperature:inc(250)
  end, { group = 'System controls', description = 'increase screen temperature' }),
  awful.key({ modkey, control }, ']', function()
    screen_temperature:dec(250)
  end, { group = 'System controls', description = 'decrease screen temperature' }),
  awful.key({ control }, 'XF86MonBrightnessUp', function()
    screen_temperature:inc(500)
  end),
  awful.key({ control }, 'XF86MonBrightnessDown', function()
    screen_temperature:dec(500)
  end),

  -- I have never used this intentinally,
  -- and have hit accidentally on occasion
  -- awful.key({ modkey }, 'n', function()
  --   notification_widget:toggle()
  -- end, { group = 'System controls', description = 'toggle notification' }),

  awful.key({ modkey }, 's', hotkeys_popup.show_help, { description = 'show help', group = 'awesome' }),
  -- awful.key({ modkey }, 'Left',   awful.tag.viewprev,        { description = 'view previous', group = 'tag' }),
  -- awful.key({ modkey }, 'Right',  awful.tag.viewnext,        { description = 'view next', group = 'tag' }),
  -- I used to set awful.tag.history.restore to function() end because of this:
  -- https://github.com/awesomeWM/awesome/issues/2780
  -- But then, after trying to make the keymap to go to urgent or restore, it would
  -- not work with it, so I deleted it and the original awful.tag.history.restore
  -- seems to be doing just fine for now, since I don't really use volatile tags.
  awful.key({ modkey }, "'", awful.tag.history.restore, { description = 'go back', group = 'tag' }),

  -- Client
  -- When layout is "max", the "j" and "k" keys cycle through clients, but the
  -- "h" and "l" keys do not. This is so I can cycle the non maxed clients and
  -- retain the ability to move left and right to switch monitors.
  awful.key({ modkey }, 'h', function()
    local actual_layout = awful.screen.focused().selected_tag.layout
    if actual_layout == limited_tile then
      client.focus = awful.client.getmaster()
    else
      awful.client.focus.global_bydirection('left')
    end

    if client.focus then client.focus:raise() end
  end, { group = 'client', description = 'focus left global' }),
  awful.key({ modkey }, 'j', function()
    local selected_tag = awful.screen.focused().selected_tag
    local actual_layout = selected_tag.layout

    if actual_layout == awful.layout.suit.max then
      awful.client.focus.byidx(1)
    elseif actual_layout == limited_tile and client.focus.x > 0 then
      awful.client.focus.byidx(1)
      -- If after moving we are the first master, then go forward
      -- by the same amount of clients in the master stack.
      if client.focus == awful.client.getmaster() then awful.client.focus.byidx(selected_tag.master_count) end
    else
      awful.client.focus.global_bydirection('down')
    end

    if client.focus then client.focus:raise() end
  end, { group = 'client', description = 'focus down global' }),
  awful.key({ modkey }, 'k', function()
    -- If there is no client, it doesn't get a screen. While this
    -- wouldn't bring any downside to this particular function, it was
    -- not really the correct way of getting the actual layout.
    -- local this_screen = awful.client.screen
    -- local actual_layout = awful.layout.get(this_screen)

    local selected_tag = awful.screen.focused().selected_tag
    local actual_layout = selected_tag.layout

    if actual_layout == awful.layout.suit.max then
      awful.client.focus.byidx(-1)
    elseif actual_layout == limited_tile and client.focus.x > 0 then
      awful.client.focus.byidx(-1)
      -- Little hacky, if after moving by index -1 the current focused
      -- client has x == 0, it means it is on the left half of the
      -- screen, so it is in the main stack.
      if client.focus.x == 0 then awful.client.focus.byidx(-1 * selected_tag.master_count) end
    else
      awful.client.focus.global_bydirection('up')
    end

    if client.focus then client.focus:raise() end
  end, { group = 'client', description = 'focus up global' }),
  awful.key({ modkey }, 'l', function()
    local actual_layout = awful.screen.focused().selected_tag.layout
    -- Again using client.focus.x to determine
    -- if it is in the main stack
    if actual_layout == limited_tile and client.focus.x == 0 then
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
    else
      awful.client.focus.global_bydirection('right')
    end

    if client.focus then client.focus:raise() end
  end, { group = 'client', description = 'focus right global' }),
  awful.key({ modkey, shift }, 'q', function()
    awful.client.focus.byidx(-1)
  end, { group = 'client', description = 'focus by index -1' }),
  awful.key({ modkey, shift }, 'w', function()
    awful.client.focus.byidx(1)
  end, { group = 'client', description = 'focus by index +1' }),

  awful.key({ modkey }, 'q', function()
    awful.screen.focus_relative(-1)
  end, { group = 'monitor', description = 'focus relative -1' }),
  awful.key({ modkey }, 'w', function()
    awful.screen.focus_relative(1)
  end, { group = 'monitor', description = 'focus relative +1' }),

  awful.key({ modkey }, 'Escape', function()
    local urgent_client = awful.client.urgent.get()
    if urgent_client then
      urgent_client:jump_to()
    else
      awful.tag.history.restore()
    end
  end, { group = 'client', description = 'jump to urgent client or restore last tag if no urgent client exists' }),
  awful.key({ modkey, shift }, 'Tab', function()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
  end, { group = 'client', description = 'go to last focused client' }),
  awful.key({ modkey }, 'Tab', function()
    awful.spawn('rofi -show window')
  end, { group = 'client', description = 'run rofi -show window' }),
  awful.key({ modkey, shift }, 'n', function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then c:emit_signal('request::activate', 'key.unminimize', { raise = true }) end
  end, { group = 'client', description = 'restore minimized' }),

  -- Layout manipulation
  awful.key({ modkey, shift }, 'h', function()
    awful.client.swap.global_bydirection('left')
  end, { group = 'client', description = 'swap left client global' }),
  awful.key({ modkey, shift }, 'j', function()
    local actual_layout = awful.screen.focused().selected_tag.layout
    if actual_layout == limited_tile then
      awful.client.swap.byidx(1)
    else
      awful.client.swap.global_bydirection('down')
    end
  end, { group = 'client', description = 'swap down client global' }),
  awful.key({ modkey, shift }, 'k', function()
    local actual_layout = awful.screen.focused().selected_tag.layout
    if actual_layout == limited_tile then
      awful.client.swap.byidx(-1)
    else
      awful.client.swap.global_bydirection('up')
    end
  end, { group = 'client', description = 'swap up client global' }),
  awful.key({ modkey, shift }, 'l', function()
    awful.client.swap.global_bydirection('right')
  end, { group = 'client', description = 'swap right client global' }),

  -- Size
  awful.key({ modkey }, 'u', function()
    awful.tag.incmwfact(-0.05)
  end, { group = 'layout', description = 'decrease master width factor' }),
  awful.key({ modkey }, 'i', function()
    awful.client.incwfact(-0.05)
  end, { group = 'layout', description = 'decrease client height' }),
  awful.key({ modkey }, 'o', function()
    awful.client.incwfact(0.05)
  end, { group = 'layout', description = 'increase client height' }),
  awful.key({ modkey }, 'p', function()
    awful.tag.incmwfact(0.05)
  end, { group = 'layout', description = 'increase master width factor' }),
  awful.key({ modkey }, 'r', function()
    local screen = awful.screen.focused()
    if not screen then return end
    local selected_tag = screen.selected_tag
    if not selected_tag then return end
    selected_tag.master_width_factor = 0.5

    local count = #screen.tiled_clients
    local factor
    if count <= 2 then
      factor = 1
    else
      factor = 1 / (count - 1)
    end

    for _, c in pairs(screen.tiled_clients) do
      awful.client.setwfact(factor, c)
    end
  end, { group = 'layout', description = 'reset clients height and width sizes (as best as we can)' }),
  awful.key({ modkey, control }, 'h', function()
    awful.tag.incncol(1, nil, true)
  end, { group = 'layout', description = 'increase the number of columns' }),
  awful.key({ modkey, control }, 'j', function()
    awful.tag.incnmaster(1, nil, true)
  end, { group = 'layout', description = 'increase the number of master clients' }),
  awful.key({ modkey, control }, 'l', function()
    awful.tag.incncol(-1, nil, true)
  end, { group = 'layout', description = 'decrease the number of columns' }),
  awful.key({ modkey, control }, 'k', function()
    awful.tag.incnmaster(-1, nil, true)
  end, { group = 'layout', description = 'decrease the number of master clients' }),

  -- Select layouts
  awful.key({ modkey }, '\\', function()
    awful.layout.inc(1)
  end, { group = 'layout', description = 'select next layout' }),
  awful.key({ modkey, shift }, '\\', function()
    awful.layout.inc(-1)
  end, { group = 'layout', description = 'select previous layout' }),

  -- Map something to arrow keys, I guess
  awful.key({ modkey }, 'Left', function()
    awful.tag.incmwfact(0.05)
  end, { group = 'layout', description = 'increase master width factor' }),
  awful.key({ modkey }, 'Right', function()
    awful.tag.incmwfact(-0.05)
  end, { group = 'layout', description = 'decrease master width factor' }),
  awful.key({ modkey }, 'Down', function()
    awful.tag.incnmaster(1, nil, true)
  end, { group = 'layout', description = 'increase the number of master clients' }),
  awful.key({ modkey }, 'Up', function()
    awful.tag.incnmaster(-1, nil, true)
  end, { group = 'layout', description = 'decrease the number of master clients' }),

  -- Standard program
  awful.key({ modkey, control }, 'r', awesome.restart, { group = 'awesome', description = 'reload awesome' }),
  awful.key({ modkey, shift }, 'BackSpace', awesome.quit, { group = 'awesome', description = 'quit awesome' }),
  awful.key({ modkey }, 'BackSpace', function()
    awful.spawn('slock')
  end, { group = 'awesome', description = 'lock screen' }),
  awful.key({ modkey, control, shift }, 'BackSpace', function()
    awful.spawn.with_shell('shutdown now')
  end, { group = 'awesome', description = 'Power off' }),

  -- Prompt
  -- awful.key({ modkey }, 'r', function () awful.screen.focused().mypromptbox:run() end,
  --           { group = 'Launcher', description = 'run prompt', }),
  -- Menubar (dmenu's brother, so it has similar keybinding)
  awful.key({ modkey, shift }, 'd', function()
    menubar.show()
  end, { group = 'Launcher', description = 'show the menubar' }),
  awful.key(
    { modkey },
    'd',
    -- function () awful.spawn('dmenu_run -i -h 21 -p "search" -sb "#008080" -nb "#363636"') end,
    -- function () awful.spawn('dmenu_run -i -h 21 -p "search" -sb "#008080" -nb "#000000"') end,
    function()
      awful.spawn('dmenu_run -i -h 21 -p "search"')
    end,
    { group = 'Launcher', description = 'run dmenu_run' }
  ),
  awful.key({ modkey, control }, 'd', function()
    awful.spawn('j4-dmenu-desktop')
  end, { group = 'Launcher', description = 'run j4-dmenu-desktop' }),
  awful.key({ modkey }, 'b', function()
    awful.spawn(browser)
  end, { group = 'Launcher', description = 'open ' .. browser .. ' browser' }),

  awful.key({ modkey }, 'space', function()
    awful.spawn('rofi -show drun')
  end, { group = 'Launcher', description = 'run rofi -show drun' }),
  awful.key({ modkey, shift }, 'space', function()
    awful.spawn('rofi -show run')
  end, { group = 'Launcher', description = 'run rofi -show run' }),

  --[[
    Explanation: When using tmux inside alacritty, I don't know why, but the
    numpad enter was producing something different (on Debian it worked as
    intented, though), which means I could not use it as enter to confirm
    things, for example. So what I did is that I used ~/.Xmodmap to map the key
    #104 (numpad enter) to Return, the same code as the key #36 (regular enter).
    After doing this, pressing the combination "modkey + numpad enter" triggered
    both "modkey+#104" and "modkey+Return" mappings, and then two terminals were
    opened. Thus, I removed the "modkey+#104" keymap and left only the Return,
    since now it works with numpad enter, because the latter now produces Return
    on my computer
  ]]
  awful.key({ shift, modkey }, 'Return', function()
    awful.spawn(terminal_tmux)
  end, { group = 'Launcher', description = 'open ' .. terminal .. ' terminal' }),
  -- The key #104 is the numpad enter
  -- awful.key({ modkey }, '#104',
  --           function () awful.spawn(terminal) end,
  --           { group = 'Launcher', description = '(numpad enter) open '..terminal..' terminal',  }),
  awful.key({ modkey }, 'Return', function()
    awful.spawn(terminal)
  end, { group = 'Launcher', description = 'open ' .. terminal .. ' terminal with tmux running' }),

  awful.key({ control, modkey }, 'Return', function()
    awful.spawn(floating_terminal)
  end, { group = 'Launcher', description = 'open floating ' .. terminal .. ' terminal' }),
  -- awful.key({ modkey, control }, '#104',
  --           function () awful.spawn(floating_terminal) end,
  --           { group = 'Launcher', description = '(numpad enter) open floating '..terminal..' terminal',  }),
  awful.key({ control, shift, modkey }, 'Return', function()
    awful.spawn(floating_terminal_tmux)
  end, { group = 'Launcher', description = 'open floating ' .. terminal .. ' terminal with tmux running' }),

  -- Prints
  ---------
  -- Basically, Control + Print is the rectangular selection
  -- Just print is the screen, hold shift to send it to clipboard
  -- Modkey + Print is all screens, hold shift to send it to clipboard

  -- Rectangular
  awful.key({ control }, 'Print', function()
    awful.spawn('flameshot gui')
  end, { group = 'Launcher', description = 'Print select area' }),

  -- Screen
  awful.key({}, 'Print', function()
    awful.spawn('flameshot screen')
  end, { group = 'Launcher', description = 'Print screen and save it to default directory' }),
  awful.key({ shift }, 'Print', function()
    awful.spawn('flameshot screen -c')
  end, { group = 'Launcher', description = 'Print screen to clipboard' }),

  -- All screens
  awful.key({ shift, modkey }, 'Print', function()
    awful.spawn('flameshot full -c')
  end, { group = 'Launcher', description = 'Print all screens to clipboard' }),
  awful.key({ modkey }, 'Print', function()
    awful.spawn('flameshot full')
  end, { group = 'Launcher', description = 'Print all screens and save it to default directory' }),

  awful.key({ modkey, shift }, 'ç', function()
    awful.spawn(scripts_dir .. '/emoji/dmenu-search-emoji.sh')
  end, { group = 'Launcher', description = 'search emojis to copy them to clipboard' }),
  awful.key({ modkey }, 'ç', function()
    awful.spawn(scripts_dir .. '/rofi-emoji.sh')
  end, { group = 'Launcher', description = 'run rofimoji script' }),

  awful.key({ modkey, control }, 'ç', function()
    turbo_widget:send_turbo_notification()
  end, { group = 'TURBO', description = 'Activate TURBO mode' }),

  awful.key({ modkey }, 'x', function()
    awful.prompt.run({
      prompt = 'Run Lua code> ',
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. '/history_eval',
    })
  end, { group = 'awesome', description = 'lua execute prompt' })
)

local clientkeys = gears.table.join(
  awful.key({ modkey }, 'f', function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { group = 'client', description = 'toggle fullscreen' }),
  awful.key({ modkey, control }, 'c', function(c)
    c:kill()
  end, { group = 'client', description = 'close' }),
  awful.key({ modkey, control }, 'space', function(c)
    awful.client.floating.toggle()
    -- Could be done like this. Is there a difference?
    -- c.floating = not c.floating
    c:raise()
  end, { group = 'client', description = 'toggle floating' }),
  awful.key({ modkey, control }, 'Return', function(c)
    c:swap(awful.client.getmaster())
  end, { group = 'client', description = 'move to master' }),
  awful.key({ modkey }, 'z', function(c)
    c:move_to_screen()
  end, { group = 'client', description = 'move to screen' }),
  awful.key({ modkey }, 't', function(c)
    c.ontop = not c.ontop
  end, { group = 'client', description = 'toggle keep on top' }),
  awful.key({ modkey, control }, 'n', function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, { group = 'client', description = 'minimize' }),
  awful.key({ modkey }, 'v', function(c)
    toggleLayout('limited_tile')
    c:raise()
  end, { group = 'client', description = 'toggle tile_só_dois layout' }),
  awful.key({ modkey }, 'm', function(c)
    c.maximized_horizontal = false
    c.maximized_vertical = false
    toggleLayout('max')
    c:raise()
  end, { group = 'client', description = 'toggle maximize layout' }),
  awful.key({ modkey, control, shift }, 'm', function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { group = 'client', description = 'toggle maximize' }),
  awful.key({ modkey, control }, 'm', function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, { group = 'client', description = 'toggle maximize vertically' }),
  awful.key({ modkey, shift }, 'm', function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, { group = 'client', description = 'toggle maximize horizontally' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- Added tag 10 (mod + 0 goes to it)
-- for i = 1, 10 do
--   globalkeys = gears.table.join(
--     globalkeys,
--     -- View tag only.
--     awful.key({ modkey }, '#' .. i + 9,
--               function ()
--                 local screen = awful.screen.focused()
--                 local tag = screen.tags[i]
--                 if tag then
--                   tag:view_only()
--                 end
--               end,
--               { group = 'tag', description = 'view tag #'..i, }),
--     -- Toggle tag display.
--     awful.key({ modkey, 'Control' }, '#' .. i + 9,
--               function ()
--                 local screen = awful.screen.focused()
--                 local tag = screen.tags[i]
--                 if tag then
--                   awful.tag.viewtoggle(tag)
--                 end
--               end,
--               { group = 'tag', description = 'toggle tag #' .. i, }),
--     -- Move client to tag.
--     awful.key({ modkey, 'Shift' }, '#' .. i + 9,
--               function ()
--                 if client.focus then
--                   local tag = client.focus.screen.tags[i]
--                   if tag then
--                     client.focus:move_to_tag(tag)
--                   end
--                 end
--               end,
--               { group = 'tag', description = 'move focused client to tag #'..i, }),
--     -- Toggle tag on focused client.
--     awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9,
--               function ()
--                 if client.focus then
--                   local tag = client.focus.screen.tags[i]
--                   if tag then
--                     client.focus:toggle_tag(tag)
--                   end
--                 end
--               end,
--               { group = 'tag', description = 'toggle focused client on tag #' .. i, })
--   )
-- end

-- Using xev, you can find the code of each number. The numpad 0 is 90, for example.
local integer_to_numpad = {
  [0] = 90,
  [1] = 87,
  [2] = 88,
  [3] = 89,
  [4] = 83,
  [5] = 84,
  [6] = 85,
  [7] = 79,
  [8] = 80,
  [9] = 81,
}
for i = 1, #tags do
  -- I only have tags whose names are numbers,
  -- from 0 to 9, so that's why this is fine.
  local tag_number = i % 10

  globalkeys = gears.table.join(
    globalkeys,
    -- View tag only.
    awful.key({ modkey }, '#' .. i + 9, function()
      charitable.select_tag(tags[i], awful.screen.focused())
    end, { group = 'tag', description = 'view tag #' .. tag_number }),
    awful.key({ modkey }, '#' .. integer_to_numpad[tag_number], function()
      charitable.select_tag(tags[i], awful.screen.focused())
    end, { group = 'tag', description = 'view tag #' .. tag_number }),
    -- Toggle tag display.
    awful.key({ modkey, control }, '#' .. i + 9, function()
      charitable.toggle_tag(tags[i], awful.screen.focused())
    end, { group = 'tag', description = 'toggle tag #' .. i }),
    awful.key({ modkey, control }, '#' .. integer_to_numpad[tag_number], function()
      charitable.toggle_tag(tags[i], awful.screen.focused())
    end, { group = 'tag', description = 'toggle tag #' .. i }),
    -- Move client to tag.
    awful.key({ modkey, shift }, '#' .. i + 9, function()
      if client.focus then
        local tag = tags[i]
        if tag then client.focus:move_to_tag(tag) end
      end
    end, { group = 'tag', description = 'move focused client to tag #' .. i }),
    awful.key({ modkey, shift }, '#' .. integer_to_numpad[tag_number], function()
      if client.focus then
        local tag = tags[i]
        if tag then client.focus:move_to_tag(tag) end
      end
    end, { group = 'tag', description = 'move focused client to tag #' .. i }),
    -- Toggle tag on focused client.
    awful.key({ modkey, control, shift }, '#' .. i + 9, function()
      if client.focus then
        local tag = tags[i]
        if tag then client.focus:toggle_tag(tag) end
      end
    end, { group = 'tag', description = 'toggle focused client on tag #' .. i }),
    awful.key({ modkey, control, shift }, '#' .. integer_to_numpad[tag_number], function()
      if client.focus then
        local tag = tags[i]
        if tag then client.focus:toggle_tag(tag) end
      end
    end, { group = 'tag', description = 'toggle focused client on tag #' .. i })
  )
end

-- ensure that removing screens doesn't kill tags
tag.connect_signal('request::screen', function(t)
  t.selected = false
  for s in screen do
    if s ~= t.screen then
      t.screen = s
      return
    end
  end
end)

local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.resize(c)
  end),
  awful.button({ modkey, shift }, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.resize(c)
  end),
  awful.button({ modkey, control }, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.resize(c)
  end),
  awful.button({ modkey, shift, control }, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- Show titlebars for floating window except some gnome software and alacritty
-- Floating alacritty is used in some scripts, alacritty has to be manually
-- spawned with the name "floating-alacritty" in order to show titlebars
local function should_show_titlebars(c)
  if type(c.class) ~= 'string' or type(c.name) ~= 'string' then return false end

  if c.fullscreen then return false end
  if c.maximized then return false end
  if c.maximized_horizontal then return false end
  if c.maximized_vertical then return false end

  if c.class == 'Alacritty' then return false end
  if c.class == 'Steam' then return false end
  if c.class == 'Evince' then return false end
  if c.class == 'Cameractrlsgtk.py' then return false end

  if c.name == 'Zoom - Free Account' then return true end
  if c.class == 'Zoom - Free Account' then return true end
  if c.name == 'zoom' then return true end
  if c.class == 'zoom' then return true end
  if c.name == 'floating-alacritty' and c.floating then return true end

  local is_some_gnome_thing = (
    string.match(c.class, '^[Gg]nome-%w*')
    or string.match(c.name, '^[Gg]nome-%w*')
    or string.match(c.class, '^[Gg]edit')
    or string.match(c.name, '^[Gg]edit')
    or string.match(c.class, '^[Oo]rg%.gnome%.%w*')
    or string.match(c.name, '^[Oo]rg%.gnome%.%w*')
  )

  if is_some_gnome_thing then return false end

  return true
end

local function request_titlebars_trying_to_keep_client_height(c)
  -- Keep the same height as before showing titlebars,
  -- avoiding a bottom part of the client to be
  -- pushed out of the window.

  -- TODO There are some applications that change size (shrink height a little
  -- bit) or start straying to the top, like kolourpaint and cheese
  -- respectively, when they are floating and I restart awesome
  -- (mod+control+r today). Try to understand why.
  local g = { x = c.x, y = c.y, height = c.height, width = c.width }
  c:emit_signal('request::titlebars')
  c:geometry(g)
end

local function titlebar_for_floating_or_maximized_client(c)
  if c.floating and should_show_titlebars(c) then
    request_titlebars_trying_to_keep_client_height(c)
  else
    local t = c:tags()[1]
    if t and t.layout.name == 'floating' then
      request_titlebars_trying_to_keep_client_height(c)
    else
      awful.titlebar.hide(c, 'top')
      awful.titlebar.hide(c, 'bottom')
      awful.titlebar.hide(c, 'left')
      awful.titlebar.hide(c, 'right')
    end
  end
end

client.connect_signal('property::floating', titlebar_for_floating_or_maximized_client)
client.connect_signal('property::maximized', titlebar_for_floating_or_maximized_client)
client.connect_signal('property::maximized_vertical', titlebar_for_floating_or_maximized_client)
client.connect_signal('property::maximized_horizontal', titlebar_for_floating_or_maximized_client)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      callback = function(c) -- make gnome things floating (but neither nautilus nor gnome terminal)
        if type(c.class) ~= 'string' then return end
        if c.class:match('[Oo]rg.[Gg]nome.[Nn]autilus') then return end
        if c.class:match('[Gg]nome%-[Tt]erminal') then return end

        if c.floating and should_show_titlebars(c) then request_titlebars_trying_to_keep_client_height(c) end

        if
          c.class == 'Zoom - Free Account'
          or string.match(c.class, '^[Gg]nome-%w*')
          or string.match(c.class, '^[Gg]edit')
          or string.match(c.class, '^[Oo]rg%.gnome%.%w*')
        then
          c.floating = true
          awful.placement.centered(c, nil)
        end
      end,
    },
  },

  -- Floating clients.
  {
    properties = { floating = true },
    rule_any = {
      instance = {
        'DTA', -- Firefox addon DownThemAll.
        'copyq', -- Includes session name in class.
        'pinentry',
        'Devtools',
      },
      type = {
        'dialog',
      },
      class = {
        'Arandr',
        'Blueman-manager',
        'Gpick',
        'Kruler',
        'MessageWin', -- kalarm.
        'Sxiv',
        'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
        'Wpa_gui',
        'veromix',
        'xtightvncviewer',
        'Zoom Meeting',
        '[Zz]oom',
        'Zoom - Free Account',
        'Polls',
        'FeatherPad',
        'Erlang',
        '[Pp]avucontrol',
        'kmines',
        'kate',
        'Navigator',
        'Notes',
        'Steam',
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        'Event Tester', -- xev.
        'floating-alacritty',
        'Zoom Meeting',
        '[Zz]oom',
        'Zoom - Free Account',
        'Polls', -- all of this is more zoom shitty non sense
        'Breakout Rooms - In Progress',
        'xdg-su: /usr/sbin/yast2',
      },
      role = {
        'AlarmWindow', -- Thunderbird's calendar.
        'ConfigManager', -- Thunderbird's about:config.
        'pop-up', -- e.g. Google Chrome's (detached) Developer Tools.
        'task_dialog',
      },
    },
    -- Have floating windows always open centered in the screen
    callback = function(c)
      awful.placement.centered(c, nil)
    end,
  },

  -- Set Firefox to always map on the tag named '2' on screen 1.
  -- { rule = { class = 'Firefox' },
  --   properties = { screen = 1, tag = '2' } },

  -- xprop | grep WM_CLASS pra descobrir (xprop em geral é muito legal)
  {
    properties = { tag = '4' },
    rule_any = {
      class = {
        'Java',
        'Postman',
        'DBeaver',
      },
      name = {
        'Java',
      },
    },
  },

  -- { rule = { class = 'steam_app_' }, properties = { tag = '7', } },
  -- { rule = { class = '[Ss]potify' }, properties = { tag = '6' } },

  -- I hate Zoom, on every update it changes this stuff, ffs
  {
    properties = { tag = '9' },
    rule_any = {
      class = {
        'Zoom Meeting',
        '[Zz]oom',
        'Zoom - Free Account',
      },
      name = {
        'Zoom Meeting',
        '[Zz]oom',
        'Zoom - Free Account',
      },
    },
  },

  {
    properties = { tag = '0' },
    rule_any = {
      class = {
        '[Dd]iscord',
      },
      name = {
        '[Dd]iscord',
      },
    },
  },

  {
    properties = { ontop = true },
    rule_any = {
      class = {
        '[Gg]nome%-mines',
        '[Gg]edit',
        'kate',
        'notes',
        'FeatherPad',
        '[Pp]avucontrol',
        'floating-alacritty',
      },
      name = {
        'Extension: %(Bitwarden %- Free Password Manager%) %- Bitwarden',
      },
    },
  },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- I wonder why is this not the default
  if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      separator_widget,
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.ontopbutton(c),
      -- awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.maximizedbutton(c),
      -- buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = 'center',
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      separator_widget,
      -- awful.titlebar.widget.floatingbutton (c),
      -- awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      -- awful.titlebar.widget.ontopbutton    (c),
      separator_widget,
      separator_widget,
      awful.titlebar.widget.minimizebutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end)

-- why
-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal(
--   'mouse::enter',
--   function(c)
--     c:emit_signal('request::activate', 'mouse_enter', { raise = false })
--   end
-- )

client.connect_signal('focus', function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal('unfocus', function(c)
  c.border_color = beautiful.border_normal
end)
-- }}}

-- Start up things
awful.spawn.with_shell('nm-applet')
-- awful.spawn.with_shell('blueman-applet')
awful.spawn.with_shell(scripts_dir .. '/killall-and-start/flameshot.sh')
awful.spawn.with_shell(scripts_dir .. '/killall-and-start/unclutter.sh')
awful.spawn.with_shell(scripts_dir .. '/killall-and-start/xplugd.sh')
awful.spawn.with_shell('xcompmgr -c -l0 -t0 -r0 -o.00')
awful.spawn.with_shell('xset r rate 220 25')
awful.spawn.with_shell('xset s off')
awful.spawn.with_shell('xset -dpms')
awful.spawn.with_shell('numlockx on')
awful.spawn.with_shell('clipmenud')
-- awful.spawn.with_shell('~/scripts/enable-touchpad-tap.sh')
-- awful.spawn.with_shell('redshift -c ~/.config/redshift/redshift.conf')
-- awful.spawn.with_shell('copyq')
-- microphone_widget:set(30)
-- volume_widget:set(50)
screen_temperature:set(5250)

-- client.connect_signal("property::class", function(c)
--    if c.class == "Spotify" then
--       c:move_to_tag(screen[1].tags[6])
--    end
-- end)

-- https://www.reddit.com/r/awesomewm/comments/6cwevs/the_purpose_of_run_lua_code/
-- Okay, I guess
Prt = function(...)
  naughty.notify({ text = table.concat({ ... }, '\t') })
end

Select_n_tag = function(n)
  if n == 0 then
    -- naughty.notify({
    --   text = 'Provided n is 0, using 10 instead'
    -- })
    n = 10
  end

  if type(n) ~= 'number' then
    naughty.notify({
      text = 'Provided n must be a number.\ntype(n) = ' .. tostring(type(n)),
    })
    return
  end

  if n <= 0 then
    naughty.notify({
      text = 'Provided n must be positive.\nn = ' .. tostring(n),
    })
    return
  end

  if n > #tags then
    naughty.notify({
      text = 'Index out of bounds.\nn = ' .. tostring(n) .. '\n#tags = ' .. tostring(#tags),
    })
    return
  end

  charitable.select_tag(tags[n], awful.screen.focused())
end
