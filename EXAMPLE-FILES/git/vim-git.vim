set notermguicolors
set colorcolumn=51
set textwidth=0
map <C-q> :wq<CR>
nmap H ^
nmap L $
nmap } }k
nmap <Space><Space> }ddggpcwf<Esc>
nnoremap <M-j> :m .+1<CR>
nnoremap <M-k> :m .-2<CR>
vnoremap <M-j> :m '>+1<CR>gv
vnoremap <M-k> :m '<-2<CR>gv

hi ColorColumn ctermfg=DarkRed ctermbg=125 guibg=DarkRed
hi Statement cterm=none term=none ctermfg=130 gui=none guifg=Brown

" vim colorscheme for 9.1

hi Added ctermfg=2 guifg=SeaGreen
hi Changed ctermfg=12 guifg=DodgerBlue
" hi ColorColumn term=reverse ctermfg=15 ctermbg=125 guibg=LightRed
hi Comment term=bold ctermfg=4 guifg=Blue
hi Conceal ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
hi Constant term=underline ctermfg=1 guifg=Magenta
hi CursorColumn term=reverse ctermbg=7 guibg=Grey90
hi CursorLine term=underline cterm=underline guibg=Grey90
hi CursorLineNr term=bold cterm=underline ctermfg=130 gui=bold guifg=Brown
hi DiffAdd term=bold ctermbg=81 guibg=LightBlue
hi DiffChange term=bold ctermbg=225 guibg=LightMagenta
hi DiffDelete term=bold ctermfg=12 ctermbg=159 gui=bold guifg=Blue guibg=LightCyan
hi DiffText term=reverse cterm=bold ctermbg=9 gui=bold guibg=Red
hi Directory term=bold ctermfg=4 guifg=Blue
hi Error term=reverse ctermfg=15 ctermbg=9 guifg=White guibg=Red
hi ErrorMsg term=standout ctermfg=15 ctermbg=1 guifg=White guibg=Red
hi FoldColumn term=standout ctermfg=4 ctermbg=248 guifg=DarkBlue guibg=Grey
hi Folded term=standout ctermfg=4 ctermbg=248 guifg=DarkBlue guibg=LightGrey
hi Identifier term=underline ctermfg=6 guifg=DarkCyan
hi Ignore ctermfg=15 guifg=bg
hi IncSearch term=reverse cterm=reverse gui=reverse
hi LineNr term=underline ctermfg=130 guifg=Brown
hi MatchParen term=reverse ctermbg=14 guibg=Cyan
hi ModeMsg term=bold cterm=bold gui=bold
hi MoreMsg term=bold ctermfg=2 gui=bold guifg=SeaGreen
hi NonText term=bold ctermfg=12 gui=bold guifg=Blue
hi Pmenu ctermfg=0 ctermbg=225 guibg=LightMagenta
hi PmenuSbar ctermbg=248 guibg=Grey
hi PmenuSel ctermfg=0 ctermbg=7 guibg=Grey
hi PmenuThumb ctermbg=0 guibg=Black
hi PreProc term=underline ctermfg=5 guifg=#6a0dad
hi Question term=standout ctermfg=2 gui=bold guifg=SeaGreen
hi Removed ctermfg=9 guifg=Red
hi Search term=reverse ctermbg=11 guibg=Yellow
hi SignColumn term=standout ctermfg=4 ctermbg=248 guifg=DarkBlue guibg=Grey
hi Special term=bold ctermfg=5 guifg=#6a5acd
hi SpecialKey term=bold ctermfg=4 guifg=Blue
hi SpellBad term=reverse ctermbg=224 gui=undercurl guisp=Red
hi SpellCap term=reverse ctermbg=81 gui=undercurl guisp=Blue
hi SpellLocal term=underline ctermbg=14 gui=undercurl guisp=DarkCyan
hi SpellRare term=reverse ctermbg=225 gui=undercurl guisp=Magenta
"hi Statement term=bold ctermfg=130 gui=bold guifg=Brown
hi StatusLine term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi StatusLineNC term=reverse cterm=reverse gui=reverse
hi StatusLineTerm term=bold,reverse cterm=bold ctermfg=15 ctermbg=2 gui=bold guifg=bg guibg=DarkGreen
hi StatusLineTermNC term=reverse ctermfg=15 ctermbg=2 guifg=bg guibg=DarkGreen
hi TabLine term=underline cterm=underline ctermfg=0 ctermbg=7 gui=underline guibg=LightGrey
hi TabLineFill term=reverse cterm=reverse gui=reverse
hi TabLineSel term=bold cterm=bold gui=bold
hi Title term=bold ctermfg=5 gui=bold guifg=Magenta
hi Todo term=standout ctermfg=0 ctermbg=11 guifg=Blue guibg=Yellow
hi ToolbarButton cterm=bold ctermfg=15 ctermbg=242 gui=bold guifg=White guibg=Grey40
hi ToolbarLine term=underline ctermbg=7 guibg=LightGrey
hi Type term=underline ctermfg=2 gui=bold guifg=SeaGreen
hi Underlined term=underline cterm=underline ctermfg=5 gui=underline guifg=SlateBlue
hi VertSplit term=reverse cterm=reverse gui=reverse
hi Visual ctermfg=0 ctermbg=248 guifg=Black guibg=LightGrey
hi WarningMsg term=standout ctermfg=1 guifg=Red
hi WildMenu term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
hi clear LineNrAbove
hi clear LineNrBelow
hi clear MsgArea
hi clear Normal
hi clear VisualNOS
hi clear gitcommitAuthor
hi clear gitcommitDiff
hi clear gitcommitDiscarded
hi clear gitcommitFirstLine
hi clear gitcommitOverflow
hi clear gitcommitSelected
hi clear gitcommitTrailers
hi clear gitcommitUnmerged
hi clear gitcommitUntracked
hi link Boolean Constant
hi link CCTreeArrow CCTreeMarkers
hi link CCTreeHiArrow CCTreeHiMarkers
hi link CCTreeHiKeyword Macro
hi link CCTreeHiMarkers NonText
hi link CCTreeHiPathMark CCTreePathMark
hi link CCTreeHiSymbol Todo
hi link CCTreeMarkExcl Ignore
hi link CCTreeMarkTilde Ignore
hi link CCTreeMarkers LineNr
hi link CCTreePathMark CCTreeArrow
hi link CCTreeSymbol Function
hi link CCTreeUpArrowBlock CCTreeHiArrow
hi link Character Constant
hi link Conditional Statement
hi link CurSearch Search
hi link CursorLineFold FoldColumn
hi link CursorLineSign SignColumn
hi link Debug Special
hi link Define PreProc
hi link Delimiter Special
hi link EndOfBuffer NonText
hi link Exception Statement
hi link Float Number
hi link Function Identifier
hi link Include PreProc
hi link Keyword Statement
hi link Label Statement
hi link Macro PreProc
hi link Number Constant
hi link Operator Statement
hi link PmenuExtra Pmenu
hi link PmenuExtraSel PmenuSel
hi link PmenuKind Pmenu
hi link PmenuKindSel PmenuSel
hi link PreCondit PreProc
hi link QuickFixLine Search
hi link Repeat Statement
hi link SpecialChar Special
hi link SpecialComment Special
hi link StorageClass Type
hi link String Constant
hi link Structure Type
hi link Tag Special
hi link Typedef Type
hi link diffAdded Added
hi link diffBDiffer Constant
hi link diffChanged Changed
hi link diffComment Comment
hi link diffCommon Constant
hi link diffDiffer Constant
hi link diffFile Type
hi link diffIdentical Constant
hi link diffIndexLine PreProc
hi link diffIsA Constant
hi link diffLine Statement
hi link diffNewFile diffFile
hi link diffNoEOL Constant
hi link diffOldFile diffFile
hi link diffOnly Constant
hi link diffRemoved Removed
hi link diffSubname PreProc
hi link gitcommitArrow gitcommitComment
hi link gitcommitBlank Error
hi link gitcommitBranch Special
hi link gitcommitComment Comment
hi link gitcommitDiscardedArrow gitcommitArrow
hi link gitcommitDiscardedFile gitcommitFile
hi link gitcommitDiscardedType gitcommitType
hi link gitcommitFile Constant
hi link gitcommitHash Identifier
hi link gitcommitHeader PreProc
hi link gitcommitNoBranch gitcommitBranch
hi link gitcommitNoChanges gitcommitHeader
hi link gitcommitOnBranch Comment
hi link gitcommitSelectedArrow gitcommitArrow
hi link gitcommitSelectedFile gitcommitFile
hi link gitcommitSelectedType gitcommitType
hi link gitcommitSummary Keyword
hi link gitcommitTrailerToken Label
hi link gitcommitType Type
hi link gitcommitUnmergedArrow gitcommitArrow
hi link gitcommitUnmergedFile gitcommitFile
hi link gitcommitUnmergedType gitcommitType
hi link gitcommitUntrackedFile gitcommitFile
