syntax on
" set synmaxcol=121 " caso a linha seja tão grande que ultrapasse 120 colunas, não tem
"                   " mais marcação de sintaxe. É interessante até para a performance
" " https://vim.fandom.com/wiki/Fix_syntax_highlighting
syntax sync minlines=256

""" Plugins """
filetype plugin on
" call plug#begin('~/.config/nvim/plugged')
" " https://github.com/yegappan/mru tentar esse qualquer dias desses
" " https://github.com/neoclide/redismru.vim ou esse

" " Joguinho
" " Plug 'ThePrimeagen/vim-be-good'
" " Plug 'alec-gibson/nvim-tetris'

" " Plug 'jghauser/mkdir.nvim'
" " Plug 'code-biscuits/nvim-biscuits'






" call plug#end()

lua <<EOF
require('init')
EOF

source $HOME/.config/nvim/color/perez-cs.vim
" lua require'colorizer'.setup()
highlight CursorLine cterm=NONE ctermbg=0 gui=NONE guibg=#434d48

" Customizando FZF
let g:fzf_layout = { 'down': '30%' }
let g:fzf_preview_window = ['right:65%:hidden', 'ctrl-/']

" " Customizando o lexima (auto close de coisas) do meu jeito
" source $HOME/.config/nvim/lexima.custom.vim
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" Eu odeio esconder as aspas
let g:vim_json_syntax_conceal=0

" Opções pro buftabs
let g:buftabline_indicators=1 " mostrar se tem alteração no arquivo ou não

""" Configurações gerais """
let &titlestring='nvim'
" Mudando a status line pra ficar algo tipo assim:
" [relative/path/to/file[+]                l:1/200,c:32]
" set statusline=%f%m%r%h%w%=\ l:%l\/%L,c:%v
" Alterei pro lualine por enquanto

" Destacar colunas depois do 80 e 120
let &colorcolumn='81,121'
highlight ColorColumn ctermbg=239 guibg=#4e4e4e

" Usar shift+tab como <C-o>, já que tab = <C-i>
" nnoremap <S-Tab> <C-o>
" <C-i> e <C-o> pulam pelos lugares que o cursor esteve
" bizarramente, <C-i> e <Tab> disparam a mesma sequência
" Logo, <S-Tab> poderia ser <C-o> pra fazer parzinho com <Tab>, que é <C-i>

" Colocar uma corzinha nos pares de parentesis/colchetes/chaves quando o cursor
" estiver sobre eles
hi MatchParen guifg=#87ff00 gui=BOLD,UNDERLINE ctermfg=yellow cterm=BOLD,UNDERLINE

" function! PreviewMarkdown()
"   let l:path=expand('%:p')
"   silent execute "!echo ".l:path." > ~/.last-md-preview.log"
"   :execute "bel vert terminal"
" endfunction

" NvimTree
source $HOME/.config/nvim/tree-config.vim
" source $HOME/.config/nvim/ported-tree-config.vim

" Alterar a cor da numeração das linhas com alguma alteração (git gutter)
set signcolumn=no
let g:gitgutter_signs=0
let g:gitgutter_highlight_linenrs=1

hi GitGutterAddLineNr          guifg=#00af00 gui=BOLD           ctermfg=34  cterm=BOLD
hi GitGutterChangeLineNr       guifg=#c39f00 gui=ITALIC,BOLD    ctermfg=3   cterm=ITALIC,BOLD
hi GitGutterDeleteLineNr       guifg=#ec2929 gui=UNDERLINE,BOLD ctermfg=red cterm=UNDERLINE,BOLD
hi GitGutterChangeDeleteLineNr guifg=#d75f00 gui=UNDERCURL,BOLD ctermfg=166 cterm=UNDERCURL,BOLD

runtime macros/matchit.vim
let ruby_foldable_groups='if def class module'

let g:closetag_filetypes = 'html,eelixir,javascript,javascriptreact'
