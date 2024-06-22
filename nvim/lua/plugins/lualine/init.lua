-- :h statusline for options

local custom_functions = require('plugins.lualine.functions')

require('lualine').setup({
  options = {
    globalstatus = true,
    icons_enabled = false,
    -- theme = 'everforest',
    theme = require('plugins.lualine.modified-everforest-theme'),
    -- theme = 'tokyonight',
    -- theme = 'catppuccin',
    component_separators = { '', '' },
    section_separators = { '', '' },
    disabled_filetypes = {},
  },
  sections = { -- sections of current buffer
    lualine_a = { custom_functions.mode },
    lualine_b = { custom_functions.getfile },
    lualine_c = { '' },
    lualine_x = {
      function()
        -- This separator, sep, is needed because "diff" might
        -- change the color of the text, changing the color of "lsp", too.
        -- Putting it here prevents the next block from having its color
        -- alterated by the previous function.
        -- Lualine apparently automatically adds it when I used this format:
        -- lualine_x = { custom_functions.diagnostics, custom_functions.diff, custom_functions.lsp },
        local sep = '%#lualine_c_command#'
        return string.format(
          '%s %s%s %s',
          custom_functions.diagnostics(),
          custom_functions.diff(),
          sep,
          custom_functions.lsp()
        )
      end,
    },
    lualine_y = { 'filetype' },
    lualine_z = { custom_functions.getlines },
  },
  inactive_sections = { -- sections of other buffers
    lualine_a = {},
    lualine_b = {},
    lualine_c = { custom_functions.getfile },
    lualine_x = { custom_functions.getlines },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {}, -- tabline is the line at the top
  extensions = {},
})

vim.cmd([[
hi lualine_x_diff_added_command  guifg=#00af00 guibg=#3c474d
hi lualine_x_diff_added_inactive guifg=#00af00
hi lualine_x_diff_added_insert   guifg=#00af00
hi lualine_x_diff_added_normal   guifg=#00af00
hi lualine_x_diff_added_replace  guifg=#00af00
hi lualine_x_diff_added_terminal guifg=#00af00
hi lualine_x_diff_added_visual   guifg=#00af00

hi lualine_x_diff_modified_command  guifg=#c39f00 guibg=#3c474d
hi lualine_x_diff_modified_inactive guifg=#c39f00
hi lualine_x_diff_modified_insert   guifg=#c39f00
hi lualine_x_diff_modified_normal   guifg=#c39f00
hi lualine_x_diff_modified_replace  guifg=#c39f00
hi lualine_x_diff_modified_terminal guifg=#c39f00
hi lualine_x_diff_modified_visual   guifg=#c39f00

hi lualine_x_diff_removed_command  guifg=#ec2929 guibg=#3c474d
hi lualine_x_diff_removed_inactive guifg=#ec2929
hi lualine_x_diff_removed_insert   guifg=#ec2929
hi lualine_x_diff_removed_normal   guifg=#ec2929
hi lualine_x_diff_removed_replace  guifg=#ec2929
hi lualine_x_diff_removed_terminal guifg=#ec2929
hi lualine_x_diff_removed_visual   guifg=#ec2929
]])
