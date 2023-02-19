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
highlight CursorLine cterm=NONE ctermbg=0 gui=NONE guibg=#434d48

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

autocmd VimEnter,WinEnter * match CustomTabsGroup /\t/
hi CustomTabsGroup guifg=#999999 gui=NONE

hi MatchParen guifg=#87ff00 gui=BOLD,UNDERLINE ctermfg=yellow cterm=BOLD,UNDERLINE

" hi Normal ctermfg=231 ctermbg=234 cterm=NONE
" 68 é um azulzinho, útil saber
" 180 é o marromzinho
" 107 é verde escuro

" Gui colors
" black         #000000
" white         #ffffff
" grey          #a8a8a8
" red           #cc0000
" green         #8ae234
" yellow        #ffff00
" blue          #729ecb
" magenta       #a97ea7
" cyan          #34e2df
" dark red      #800000
" light green   #77eaae
" bright yellow #ffff87

hi Search guibg=#ffff87

hi Comment guifg=#a8a8a8 guibg=NONE gui=NONE ctermfg=grey ctermbg=NONE cterm=NONE

hi Type      guifg=#77eaae gui=NONE
hi Directory guifg=#729ecb

hi Boolean guifg=#8ae234 guibg=NONE gui=NONE ctermfg=green ctermbg=NONE cterm=NONE
hi Float   guifg=#afffaf guibg=NONE gui=NONE ctermfg=157   ctermbg=NONE cterm=NONE
hi Number  guifg=#ffff87 guibg=NONE gui=NONE ctermfg=228   ctermbg=NONE cterm=NONE
hi String  guifg=#ff875f guibg=NONE gui=NONE ctermfg=209   ctermbg=NONE cterm=NONE

hi Function    guifg=#ffff87 guibg=NONE gui=NONE ctermfg=228     ctermbg=NONE cterm=NONE
hi Define      guifg=#a97ea7                     ctermfg=magenta
hi Conditional guifg=#a97ea7 guibg=NONE gui=NONE ctermfg=magenta ctermbg=NONE cterm=NONE
hi Keyword     guifg=#a97ea7 guibg=NONE gui=NONE ctermfg=magenta ctermbg=NONE cterm=NONE
hi Identifier  guifg=#34e2df guibg=NONE gui=NONE ctermfg=cyan    ctermbg=NONE cterm=NONE
hi Operator    guifg=#ffffff guibg=NONE gui=NONE ctermfg=white   ctermbg=NONE cterm=NONE

hi Character    guifg=#cc0000 guibg=NONE gui=NONE ctermfg=red ctermbg=NONE cterm=NONE
hi Constant     guifg=#ffffff guibg=NONE gui=NONE ctermfg=white ctermbg=NONE cterm=NONE
hi Label        guifg=#729ecb guibg=NONE gui=NONE ctermfg=blue ctermbg=NONE cterm=NONE
hi PreProc      guifg=#a97ea7 guibg=NONE gui=NONE ctermfg=magenta ctermbg=NONE cterm=NONE
hi Special      guifg=#729ecb guibg=NONE gui=NONE ctermfg=blue ctermbg=NONE cterm=NONE
hi Statement    guifg=#a97ea7 guibg=NONE gui=NONE ctermfg=magenta ctermbg=NONE cterm=NONE
hi Title        guifg=#ffffff guibg=NONE gui=NONE ctermfg=231 ctermbg=NONE cterm=NONE

" Cores que só eles têm
hi SpecialKey   guifg=#5f5f87 guibg=NONE gui=NONE ctermfg=60 ctermbg=NONE cterm=NONE
hi StorageClass guifg=#87d75f guibg=NONE gui=NONE ctermfg=113 ctermbg=NONE cterm=NONE
hi Tag          guifg=#afd7ff guibg=NONE gui=NONE ctermfg=153 ctermbg=NONE cterm=NONE

hi Folded     guifg=#000000 guibg=#a8a8a8 gui=UNDERLINE ctermbg=gray
hi FoldColumn guifg=#ffffff guibg=#ffffff               ctermbg=gray ctermfg=white cterm=UNDERLINE
" hi Folded     guifg=#00ff00 guibg=NONE gui=UNDERLINE ctermbg=NONE cterm=UNDERLINE
" hi FoldColumn guifg=#ff0000 guibg=NONE gui=UNDERLINE ctermbg=NONE cterm=UNDERLINE

" hi StatusLineNC
" hi StatusLine

" Aquele menu roxo esquisitinho
" hi Pmenu    guifg=#000000 guibg=#ad7fa8
" hi PmenuSel guifg=#000000 guibg=#a8a8a8 gui=BOLD

hi Pmenu    guifg=#000000 guibg=#999999
hi PmenuSel guifg=#c9c9c9 guibg=#0f0f0f gui=BOLD

" hi Pmenu    guifg=#c9c9c9 guibg=#222222
" hi PmenuSel guifg=#c9c9c9 guibg=#0f0f0f gui=BOLD

hi TSNumber         guifg=#afffaf ctermfg=157
hi TSFloat          guifg=#ffff00 ctermfg=yellow
hi TSPunctDelimiter guifg=#ffffff ctermfg=white
hi TSSymbol         guifg=#729ecb ctermfg=blue
" hi TSPunctBracket   guifg=#875fff ctermfg=99
" hi TSPunctSpecial   guifg=#875fff ctermfg=99
hi TSPunctBracket   guifg=#8787ff ctermfg=99
hi TSPunctSpecial   guifg=#8787ff ctermfg=99
hi TSConstant       guifg=#ffffff ctermfg=white
hi TSParameter      guifg=#34e2df ctermfg=cyan
hi TSLabel          guifg=#34e2df ctermfg=cyan
hi TSKeyword        guifg=#a97ea7 ctermfg=magenta
hi TSException      guifg=#a97ea7 ctermfg=magenta
hi TSVariable       guifg=#ffffff ctermfg=white
" hi TSStringRegex    guifg=#ef2929 ctermfg=1
hi TSStringRegex    guifg=#d14d52 ctermfg=1
hi TSStringEscape   guifg=#fc84d4 ctermfg=213
" hi TSAttribute      guifg=#34e2df ctermfg=cyan gui=BOLD cterm=BOLD
hi TSAttribute      guifg=#34e2df ctermfg=cyan gui=NONE cterm=BOLD

" React
hi TSConstructor guifg=#77eaae
hi TSTag guifg=#729ecb

" HTML
" hi htmlTagName guifg=#000000
hi htmlTSTag guifg=#729ecb
hi htmlTSTagDelimiter guifg=#77eaae
hi htmlEndTag guifg=#a97ea7

" hi markdownH1Delimiter guifg=#ffffff
" hi markdownH2Delimiter guifg=#ffffff
" hi markdownH3Delimiter guifg=#ffffff
" hi markdownH4Delimiter guifg=#ffffff
" hi markdownH5Delimiter guifg=#ffffff
" hi markdownH6Delimiter guifg=#ffffff
" hi markdownH7Delimiter guifg=#ffffff
" hi markdownBlockQuote guifg=#ffffff

" hi NormalFloat guifg=#ffffff guibg=#000000
" hi NormalFloat guifg=#ffffff guibg=#282c34
hi NormalFloat guifg=#ffffff guibg=#202124

" Isso tava deixando o arquivo todo vermelho
" toda vez que tinha algum # erro de sintaxe,
" tipo wtf? Que porra.
hi error guibg=none
