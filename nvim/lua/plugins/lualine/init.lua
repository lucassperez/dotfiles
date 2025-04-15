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

-- TODO After updating to neovim 0.11.0, the gitsigns became bold
-- and I don't know why and this irritates me A LOT.
-- Also, it switched the guifg and guibg. Whaaat.
-- Did the statusline highlight color string change?
vim.cmd([[
hi lualine_x_diff_added_command     guibg=#00af00 guifg=#3c474d gui=none
hi lualine_x_diff_added_inactive    guibg=#00af00 gui=none
hi lualine_x_diff_added_insert      guibg=#00af00 gui=none
hi lualine_x_diff_added_normal      guibg=#00af00 gui=none
hi lualine_x_diff_added_replace     guibg=#00af00 gui=none
hi lualine_x_diff_added_terminal    guibg=#00af00 gui=none
hi lualine_x_diff_added_visual      guibg=#00af00 gui=none

hi lualine_x_diff_modified_command  guibg=#c39f00 guifg=#3c474d gui=none
hi lualine_x_diff_modified_inactive guibg=#c39f00 gui=none
hi lualine_x_diff_modified_insert   guibg=#c39f00 gui=none
hi lualine_x_diff_modified_normal   guibg=#c39f00 gui=none
hi lualine_x_diff_modified_replace  guibg=#c39f00 gui=none
hi lualine_x_diff_modified_terminal guibg=#c39f00 gui=none
hi lualine_x_diff_modified_visual   guibg=#c39f00 gui=none

hi lualine_x_diff_removed_command   guibg=#ec2929 guifg=#3c474d gui=none
hi lualine_x_diff_removed_inactive  guibg=#ec2929 gui=none
hi lualine_x_diff_removed_insert    guibg=#ec2929 gui=none
hi lualine_x_diff_removed_normal    guibg=#ec2929 gui=none
hi lualine_x_diff_removed_replace   guibg=#ec2929 gui=none
hi lualine_x_diff_removed_terminal  guibg=#ec2929 gui=none
hi lualine_x_diff_removed_visual    guibg=#ec2929 gui=none
]])
