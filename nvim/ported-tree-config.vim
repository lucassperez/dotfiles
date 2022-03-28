lua <<EOF
vim.g.nvim_tree_indent_markers = 0
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 0
vim.g.nvim_tree_icon_padding = ' '
vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_special_files = { -- show different color for these files
  ['README.MD'] = 1,
  ['README.md'] = 1,
  Makefile = 1,
  MAKEFILE = 1,
}
vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 0,
  folder_arrows = 0,
}
vim.g.nvim_tree_icons = {
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
    empty = "ö",
    empty_open = "ø",
    symlink = "ş",
    symlink_open = "ţ",
  },
}
vim.g.nvim_tree_symlink_arrow = 'ş»'
vim.g.nvim_tree_create_in_closed_folder = 1
local tree_cb = require('nvim-tree.config').nvim_tree_callback
require('nvim-tree').setup {
  disable_netrw             = false,
  hijack_netrw              = true,
  auto_open                 = false,
  auto_close                = false,
  tab_open                  = true,
  update_cwd                = true,
  hijack_cursor             = false,
  follow                    = false,
  auto_resize               = false,
  disable_default_keybings  = true,
  hide_dotfiles             = false,
  ignore = { '.git', 'node_modules', '.cache' },
  actions = {
    open_file = {
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
  git = { ignore = true },
  view = {
    mappings = {
      list = {
        { key = "l", cb = tree_cb("edit") },
        { key = "h", cb = tree_cb("close_node") },
      }
    }
  }
}
EOF
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" a list of groups can be found at `:help nvim_tree_highlight`
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
