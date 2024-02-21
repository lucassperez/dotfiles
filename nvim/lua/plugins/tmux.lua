require('tmux').setup({
  resize = {
    enable_default_keybindings = false,
  },
  copy_sync = {
    enable = false,
  },
  navigation = {
    -- cycles to opposite pane while navigating into the border
    cycle_navigation = true,
    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = true,
  },
})
