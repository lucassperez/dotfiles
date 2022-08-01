syntax on
" set synmaxcol=121 " caso a linha seja tão grande que ultrapasse 120 colunas, não tem
"                   " mais marcação de sintaxe. É interessante até para a performance
" " https://vim.fandom.com/wiki/Fix_syntax_highlighting
syntax sync minlines=256

filetype plugin on

lua <<EOF
require('init')
EOF

source $HOME/.config/nvim/color/perez-cs.vim
" source $HOME/.config/nvim/color/general.vim
" lua require'colorizer'.setup()
highlight CursorLine cterm=NONE ctermbg=0 gui=NONE guibg=#434d48

" Customizando FZF
let g:fzf_layout = { 'down': '30%' }
let g:fzf_preview_window = ['right:65%:hidden', 'ctrl-/']

" Opções pro buftabs
let g:buftabline_indicators=1 " mostrar se tem alteração no arquivo ou não

""" Configurações gerais """
let &titlestring='nvim'
" Antes do lualine, eu usava isso e não queria deletar (:
" [relative/path/to/file[+]                l:1/200,c:32]
" set statusline=%f%m%r%h%w%=\ l:%l\/%L,c:%v

" Destacar colunas depois do 80 e 120
let &colorcolumn='81,121'

" Alterar a cor da numeração das linhas com alguma alteração (git gutter)
set signcolumn=no
let g:gitgutter_signs=0
let g:gitgutter_highlight_linenrs=1

hi GitGutterAddLineNr          guifg=#00af00 gui=BOLD           ctermfg=34  cterm=BOLD
hi GitGutterChangeLineNr       guifg=#c39f00 gui=ITALIC,BOLD    ctermfg=3   cterm=ITALIC,BOLD
hi GitGutterDeleteLineNr       guifg=#ec2929 gui=UNDERLINE,BOLD ctermfg=red cterm=UNDERLINE,BOLD
hi GitGutterChangeDeleteLineNr guifg=#d75f00 gui=UNDERCURL,BOLD ctermfg=166 cterm=UNDERCURL,BOLD

hi lualine_x_diff_added_command  guifg=#00af00
hi lualine_x_diff_added_inactive guifg=#00af00
hi lualine_x_diff_added_insert   guifg=#00af00
hi lualine_x_diff_added_normal   guifg=#00af00
hi lualine_x_diff_added_replace  guifg=#00af00
hi lualine_x_diff_added_terminal guifg=#00af00
hi lualine_x_diff_added_visual   guifg=#00af00

hi lualine_x_diff_modified_command  guifg=#c39f00
hi lualine_x_diff_modified_inactive guifg=#c39f00
hi lualine_x_diff_modified_insert   guifg=#c39f00
hi lualine_x_diff_modified_normal   guifg=#c39f00
hi lualine_x_diff_modified_replace  guifg=#c39f00
hi lualine_x_diff_modified_terminal guifg=#c39f00
hi lualine_x_diff_modified_visual   guifg=#c39f00

hi lualine_x_diff_removed_command  guifg=#ec2929
hi lualine_x_diff_removed_inactive guifg=#ec2929
hi lualine_x_diff_removed_insert   guifg=#ec2929
hi lualine_x_diff_removed_normal   guifg=#ec2929
hi lualine_x_diff_removed_replace  guifg=#ec2929
hi lualine_x_diff_removed_terminal guifg=#ec2929
hi lualine_x_diff_removed_visual   guifg=#ec2929

runtime macros/matchit.vim
let ruby_foldable_groups='if def class module'

let g:closetag_filetypes='html,eelixir,javascript,javascriptreact,typescript,typescriptreact,template,vue'

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

nnoremap <F1> :call SynGroup()<CR>
