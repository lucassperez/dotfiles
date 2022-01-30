set termguicolors
set background=dark
" Normal é o background geral
hi Normal ctermbg=NONE guibg=NONE

" Cor dos comentários
highlight Comment ctermfg=grey guifg=#a8a8a8

" Cor dos números das linhas:
""" Todas as linhas:
highlight LineNr ctermfg=grey guifg=#a8a8a8
""" Linha atual:
highlight CursorLineNr cterm=NONE gui=NONE guifg=#e2e209

" Cor da coluna que pode-se colocar
highlight ColorColumn ctermbg=239 guibg=#4e4e4e

" destacar e estilizar a linha atual do cursor
" highlight CursorLine cterm=NONE ctermbg=0 gui=NONE guibg=#2e3436
highlight CursorLine cterm=NONE ctermbg=0 gui=NONE guibg=#4e4e4e

" TODO aprender como funciona o showmode, corzinhas etc e tal
highlight Todo ctermfg=white ctermbg=darkyellow guifg=#d9d9d9 guibg=#808000

hi clear Visual
hi Visual cterm=REVERSE gui=REVERSE

hi DiffAdd    guifg=#00af00 guibg=#5f8700 gui=NONE ctermfg=231 ctermbg=64  cterm=NONE
hi DiffDelete guifg=#ec2929 guibg=#d75f5f gui=NONE ctermfg=88  ctermbg=167 cterm=NONE
hi DiffChange guifg=#c39f00 guibg=#5f87d7 gui=NONE ctermfg=231 ctermbg=68  cterm=NONE
" hi DiffText   ctermfg=231 ctermbg=61  cterm=bold guifg=#ffffff guibg=#5f5faf gui=bold
" hi ErrorMsg ctermfg=131 ctermbg=231 cterm=reverse guifg=#af5f5f guibg=#ffffff gui=reverse
" hi WarningMsg ctermfg=180 ctermbg=NONE cterm=NONE guifg=#d7af87 guibg=NONE gui=NONE
hi NonText          guifg=#729ecb
hi TabLine          guifg=#616163 guibg=#2e3436 gui=NONE ctermfg=242 ctermbg=0 cterm=NONE
hi BufTabLineActive guibg=#6c6c6c                        ctermfg=15  ctermbg=242

hi link Define Statement

match CustomTabsGroup /\t/
hi CustomTabsGroup guifg=#999999 gui=NONE

hi MatchParen guifg=#87ff00 gui=BOLD,UNDERLINE ctermfg=yellow cterm=BOLD,UNDERLINE
