local function getlines ()
  return [[%l/%L:%v]]
end

local function getfile ()
  return [[%f%m%r%h%w]]
end

local function customModes ()
  local current_mode = vim.api.nvim_get_mode().mode
  local t = {
    ['n']      = 'NORMAL',
    ['no']     = 'O-PENDING',
    ['nov']    = 'O-PENDING',
    ['noV']    = 'O-PENDING',
    ['no\22']  = 'O-PENDING',
    ['niI']    = 'NORMAL',
    ['niR']    = 'NORMAL',
    ['niV']    = 'NORMAL',
    ['nt']     = 'NORMAL',
    ['ntT']    = 'NORMAL',
    ['v']      = 'VISUAL',
    ['vs']     = 'VISUAL',
    ['V']      = 'V-LINE',
    ['Vs']     = 'V-LINE',
    ['\22']    = 'V-BLCK',
    ['\22s']   = 'V-BLCK',
    ['s']      = 'SELECT',
    ['S']      = 'S-LINE',
    ['\19']    = 'S-BLCK',
    ['i']      = 'INSERT',
    ['ic']     = 'INSERT',
    ['ix']     = 'INSERT',
    ['R']      = 'REPLCE',
    ['Rc']     = 'REPLCE',
    ['Rx']     = 'REPLCE',
    ['Rv']     = 'V-REPLCE',
    ['Rvc']    = 'V-REPLCE',
    ['Rvx']    = 'V-REPLCE',
    ['c']      = 'COMMND',
    ['cv']     = 'EX',
    ['ce']     = 'EX',
    ['r']      = 'REPLCE',
    ['rm']     = 'MORE',
    ['r?']     = 'CONFIRM',
    ['!']      = 'SHELL',
    ['t']      = 'TERMINAL',
  }

  return t[current_mode] or current_mode
end

-- require('lualine').setup()
require('lualine').setup {
  options = {
    -- globalstatus = true,
    icons_enabled = false,
    -- theme = 'everforest',
    theme = require('plugins.modified-everforest-theme'),
    -- theme = 'tokyonight',
    -- theme = 'catppuccin',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = { -- sections of current buffer
    -- lualine_a = {'mode'},
    lualine_a = {customModes},
    lualine_b = {getfile},
    lualine_c = {''},
    -- lualine_c = {'lsp_progress'},
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
