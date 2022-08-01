local tree_cb = require('nvim-tree.config').nvim_tree_callback
require('nvim-tree').setup {
  disable_netrw             = false,
  hijack_netrw              = true,
  open_on_setup             = false,
  open_on_tab               = true,
  update_cwd                = true,
  hijack_cursor             = false,
  create_in_closed_folder   = true,
  respect_buf_cwd = true,
  update_focused_file = { enable = false },
  filters = {
    dotfiles = false,
    custom = { '.git', 'node_modules', '.cache' },
  },
  actions = {
    open_file = {
      resize_window = false,
      window_picker = {
        enable = true,
        exclude = {
          filetype = { 'packer', 'qf' },
          buftype = { 'terminal' },
        }
      },
      quit_on_open = false,
    },
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = 'all', -- 'none', 'icon', 'name' or 'all'
    root_folder_modifier = ':~',
    add_trailing = true,
    group_empty = false,
    icons = {
      symlink_arrow = 'ş»',
      padding = ' ',
      show = {
        git = true,
        file = false,
        folder = true,
        folder_arrow = false,
      },
      glyphs = {
        default = ' ',
        symlink = '»',
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "U",
          renamed = "➜",
          untracked = "★",
          deleted = "D",
          ignored = "i"
        },
        folder = {
          arrow_open = "å",
          arrow_closed = "ă",
          default = ">",
          open = "v",
          empty = "ø",
          empty_open = "ö",
          symlink = "ş",
          symlink_open = "ţ",
        },
      },
    },
    indent_markers = { enable = false },
    special_files = { 'README.MD', 'README.md', 'Makefile', 'MAKEFILE', },
  },
  git = { ignore = true },
  view = {
    mappings = {
      list = {
        { key = 'l', action = 'edit' },
        { key = 'h', action = 'close_node' },
      }
    }
  }
}

vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFindFile<CR>', { noremap = true, silent = false })

-- The list of groups can be found at `:help nvim_tree_highlight`
vim.cmd([[
hi link NvimTreeGitIgnored Comment
hi NvimTreeGitNew     guifg=#a97ea7
hi NvimTreeGitStaged  guifg=#00af00
hi NvimTreeGitMerge   guifg=#ffff87

hi NvimTreeGitRenamed guifg=NONE
hi NvimTreeGitDirty   guifg=NONE
hi NvimTreeGitDeleted guifg=NONE

hi NvimTreeRootFolder   guifg=NONE gui=BOLD
hi NvimTreeOpenedFile   guifg=NONE    gui=BOLD
hi NvimTreeIndentMarker guifg=#8094b4
hi NvimTreeSymlink      guifg=#06989a gui=BOLD
hi NvimTreeExecFile     guifg=#4e9a06 gui=BOLD
hi NvimTreeImageFile    guifg=#4e9a06 gui=BOLD
hi NvimTreeSpecialFile  guifg=#c4a000 gui=BOLD,UNDERLINE

hi NvimTreeWindowPicker guifg=#ededed guibg=#4493c8 gui=BOLD
]])
