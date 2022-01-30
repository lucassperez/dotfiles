local tema_modificado = require('plugins.modified-everforest-theme')

local function getlines ()
  return [[%l/%L:%v]]
end

local function getfile ()
  return [[%f%m%r%h%w]]
end

-- require('lualine').setup()
require('lualine').setup {
  options = {
    icons_enabled = false,
    -- theme = 'everforest',
    theme = tema_modificado,
    -- theme = 'tokyonight',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = { -- sections of current buffer
    lualine_a = {'mode'},
    lualine_b = {getfile},
    lualine_c = {''},
    lualine_x = {'diff'},
    lualine_y = {'filetype'},
    lualine_z = {getlines}
  },
  inactive_sections = { -- sections of other buffers
    lualine_a = {},
    lualine_b = {},
    lualine_c = {getfile},
    lualine_x = {getlines},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {}, -- tabline is the line at the top
  extensions = {}
}
