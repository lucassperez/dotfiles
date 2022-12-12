syntax on
" set synmaxcol=121 " caso a linha seja tão grande que ultrapasse 120 colunas, não tem
"                   " mais marcação de sintaxe. É interessante até para a performance
" " https://vim.fandom.com/wiki/Fix_syntax_highlighting
syntax sync minlines=256

filetype plugin on

lua <<EOF
require('init')
EOF

" source $HOME/.config/nvim/color/perez-cs.vim
" source $HOME/.config/nvim/color/general.vim
" lua require('colorizer').setup()

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

hi DiffAdd guibg=NONE
hi DiffChange guibg=NONE
hi DiffDelete guibg=NONE
hi DiffText guibg=NONE

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

" auto close tags
let g:closetag_filetypes='html,eelixir,javascript,javascriptreact,typescript,typescriptreact,template,vue'

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

nnoremap <F1> :call SynGroup()<CR>

" vim-sexp mappings
let g:sexp_mappings = {
      \ 'sexp_outer_list':                'af',
      \ 'sexp_inner_list':                'if',
      \ 'sexp_outer_top_list':            'aF',
      \ 'sexp_inner_top_list':            'iF',
      \ 'sexp_outer_string':              'as',
      \ 'sexp_inner_string':              'is',
      \ 'sexp_outer_element':             'ae',
      \ 'sexp_inner_element':             'ie',
      \ 'sexp_move_to_prev_bracket':      '(',
      \ 'sexp_move_to_next_bracket':      ')',
      \ 'sexp_move_to_prev_element_head': '<M-a>',
      \ 'sexp_move_to_next_element_head': '<M-s>',
      \ 'sexp_move_to_prev_element_tail': 'g<M-e>',
      \ 'sexp_move_to_next_element_tail': '<M-e>',
      \ 'sexp_flow_to_prev_close':        '<M-[>',
      \ 'sexp_flow_to_next_open':         '<M-]>',
      \ 'sexp_flow_to_prev_open':         '<M-{>',
      \ 'sexp_flow_to_next_close':        '<M-}>',
      \ 'sexp_flow_to_prev_leaf_head':    '<M-S-b>',
      \ 'sexp_flow_to_next_leaf_head':    '<M-S-w>',
      \ 'sexp_flow_to_prev_leaf_tail':    '<M-S-g>',
      \ 'sexp_flow_to_next_leaf_tail':    '<M-S-e>',
      \ 'sexp_move_to_prev_top_element':  '[[',
      \ 'sexp_move_to_next_top_element':  ']]',
      \ 'sexp_select_prev_element':       '[e',
      \ 'sexp_select_next_element':       ']e',
      \ 'sexp_indent':                    '==',
      \ 'sexp_indent_top':                '=-',
      \ 'sexp_round_head_wrap_list':      '<LocalLeader>i',
      \ 'sexp_round_tail_wrap_list':      '<LocalLeader>I',
      \ 'sexp_square_head_wrap_list':     '<LocalLeader>[',
      \ 'sexp_square_tail_wrap_list':     '<LocalLeader>]',
      \ 'sexp_curly_head_wrap_list':      '<LocalLeader>{',
      \ 'sexp_curly_tail_wrap_list':      '<LocalLeader>}',
      \ 'sexp_round_head_wrap_element':   '<LocalLeader>w',
      \ 'sexp_round_tail_wrap_element':   '<LocalLeader>W',
      \ 'sexp_square_head_wrap_element':  '<LocalLeader>e[',
      \ 'sexp_square_tail_wrap_element':  '<LocalLeader>e]',
      \ 'sexp_curly_head_wrap_element':   '<LocalLeader>e{',
      \ 'sexp_curly_tail_wrap_element':   '<LocalLeader>e}',
      \ 'sexp_insert_at_list_head':       '<LocalLeader>h',
      \ 'sexp_insert_at_list_tail':       '<LocalLeader>l',
      \ 'sexp_splice_list':               '<LocalLeader>@',
      \ 'sexp_convolute':                 '<LocalLeader>?',
      \ 'sexp_raise_list':                '<LocalLeader>o',
      \ 'sexp_raise_element':             '<LocalLeader>O',
      \ 'sexp_swap_element_backward':     '<M-.>',
      \ 'sexp_swap_list_forward':         '<M-;>',
      \ 'sexp_swap_list_backward':        '<M-,>',
      \ 'sexp_swap_element_forward':      '<M-/>',
      \ 'sexp_emit_head_element':         '<M-h>',
      \ 'sexp_emit_tail_element':         '<M-j>',
      \ 'sexp_capture_prev_element':      '<M-k>',
      \ 'sexp_capture_next_element':      '<M-l>',
      \ }

let g:lexima_enable_basic_rules = 0
let g:lexima_enable_newline_rules = 1
let g:lexima_enable_endwise_rules = 1

" https://stackoverflow.com/questions/3878692/how-to-create-an-alias-for-a-command-in-vim
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
call SetupCommandAlias('W',   'w')
call SetupCommandAlias('Wq',  'wq')
call SetupCommandAlias('Wqa', 'wqa')
call SetupCommandAlias('Wa',  'wa')
call SetupCommandAlias('Q',   'q')
call SetupCommandAlias('Qa',  'qa')
