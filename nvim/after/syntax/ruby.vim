" " Alterando as cores dos grupos definidos em
" " https://github.com/vim-ruby/vim-ruby
" " O vim-polyglot carrega esses grupos aí
" " Lucas Perez, janeiro de 2021
" """"""""""""""""""""""""""""""""""""""""""""
" " Alterado linha 453 no grupo rubyKeywordAsMethod, remover "transparent"
" """"""""""""""""""""""""""""""""""""""""""""
" " rubyString < String
" " rubyStringDelimiter < Delimiter
" " rubySymbol < Constant
" " rubySymbolDelimiter < rubySymbol
" " rubyFunction < Function
" " rubyMethodName < rubyFunction
" " rubyControl < Statement
" """"""""""""""""""""""""""""""""""""""""""""
"
" " hi rubyFloat ctermfg=yellow
" hi rubyInteger ctermfg=157
"
" " hi rubyString ctermfg=209
" " hi rubyStringDelimiter ctermfg=209
"
" hi rubySymbol ctermfg=blue
" hi rubySymbolDelimiter ctermfg=blue
"
" hi rubyInterpolationDelimiter ctermfg=99
"
" hi rubyRegexp ctermfg=red
" hi rubyRegexpSpecial ctermfg=red
" hi rubyRegexpDelimiter ctermfg=red
"
" hi rubyMethodName ctermfg=227
"
" " rubyClass, rubyModule e rubyExceptionHandler2 todos
" " têm a mesma cor de "rubyDefine"
" hi rubyDefine ctermfg=magenta
"
" " break, in, next, redo, retry, return
" " hi rubyControl ctermfg=blue
" hi rubyControl ctermfg=magenta
"
" " Coisas tipo "private"
" hi rubyAccess ctermfg=red cterm=bold
"
" " " rspec
" " syn match rspecMatchers /.to\s\|.to_not\s\|.not_to/
" " hi rspecMatchers cterm=bold
"
" hi rspecGroupMethods ctermfg=magenta
" hi rspecBeforeAndAfter ctermfg=magenta
"
" " Booleanos e nil ambos verdinhos
" syn match rubyNil /\<nil\>/
" hi rubyNil ctermfg=green
" hi rubyBoolean ctermfg=green
