let g:nvim_tree_quit_on_open = 0 "0 by default, closes the tree when you open a file
let g:nvim_tree_indent_markers = 0 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 3 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 0 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
let g:nvim_tree_special_files = { 'README.MD': 1, 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }
let g:nvim_tree_icons = {
    \ 'default': ' ',
    \ 'symlink': '»',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "U",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "D",
    \   'ignored': "i"
    \  },
    \ 'folder': {
    \   'arrow_open': "å",
    \   'arrow_closed': "ă",
    \   'default': ">",
    \   'open': "v",
    \   'empty': "ö",
    \   'empty_open': "ø",
    \   'symlink': "ş",
    \   'symlink_open': "ţ",
    \   },
    \   'lsp': {
    \     'hint': "O",
    \     'info': "?",
    \     'warning': "!",
    \     'error': "X",
    \   }
    \ }

lua <<EOF
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

" A list of groups can be found at `:help nvim_tree_highlight`
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
