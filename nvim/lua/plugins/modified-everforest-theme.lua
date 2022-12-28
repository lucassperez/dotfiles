-- https://github.com/hoob3rt/lualine.nvim/blob/master/lua/lualine/themes/everforest.lua
-- Copyright (c) 2020-2021 gnuyent
-- MIT license, see LICENSE for more details.
-- LuaFormatter off
local colors = {
  bg0    = '#323d43',
  bg1    = '#3c474d',
  bg3    = '#505a60',
  fg     = '#d8caac',
  aqua   = '#87c095',
  green  = '#a7c080',
  orange = '#e39b7b',
  purple = '#d39bb6',
  red    = '#e68183',
  grey1  = '#868d80',
  grey2  = '#bbc2cf',
  -- modified part
  preto  = '#000000',
  branco = '#ffffff',
}
-- LuaFormatter on
return {
  normal = {
    a = { bg = colors.green, fg = colors.bg0, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg }
  },
  insert = {
    a = { bg = colors.fg, fg = colors.bg0, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg }
  },
  visual = {
    a = { bg = colors.red, fg = colors.bg0, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg }
  },
  replace = {
    a = { bg = colors.orange, fg = colors.bg0, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg }
  },
  command = {
    a = { bg = colors.aqua, fg = colors.bg0, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg }
  },
  terminal = {
    a = { bg = colors.purple, fg = colors.bg0, gui = 'bold' },
    b = { bg = colors.bg3, fg = colors.fg },
    c = { bg = colors.bg1, fg = colors.fg }
  },
  inactive = {
    a = { bg = colors.grey2, fg = colors.preto, gui = 'bold' },
    b = { bg = colors.grey2, fg = colors.preto },
    c = { bg = colors.grey2, fg = colors.preto }
  },
  -- inactive = {
  --   a = { bg = colors.bg1, fg = colors.fg, gui = 'bold' },
  --   b = { bg = colors.bg1, fg = colors.fg },
  --   c = { bg = colors.bg1, fg = colors.fg }
  -- },
}
