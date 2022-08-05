source $HOME/.config/nvim/color/general.vim
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

source ~/.config/nvim/color/react?.vim
source ~/.config/nvim/color/html.vim

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
