" " Alterando as cores dos grupos definidos em
" " https://github.com/pangloss/vim-javascript
" " O vim-polyglot carrega esse de cima!
" " Lucas Perez, janeiro de 2020
" """"""""""""""""""""""""""""""""""""""""""""
"
" " import, export, "module" as, from, *
" hi Include ctermfg=magenta
" hi jsModuleAsterisk ctermfg=cyan
" hi jsModuleBraces ctermfg=cyan
"
" " Chaves e colchetes quando usados para uma desestruturação
" hi jsDestructuringBraces ctermfg=205
"
" """ Strings. Template braces é ${}
" hi String ctermfg=209
" hi link jsString               String
" hi link jsObjectKeyString      String
" hi jsTemplateString ctermfg=211
" hi link jsObjectStringKey      String
" hi link jsClassStringKey       String
" hi jsTemplateBraces ctermfg=99
"
" """ return, if, else, switch, for e while
" hi jsReturn ctermfg=magenta
" hi jsConditional ctermfg=magenta
" hi jsRepeat ctermfg=magenta
" hi jsSwitchCase ctermfg=magenta
" hi link jsLabel jsSwitchCase
"
" """ with, yield, debugger, break, continue
" hi jsStatement ctermfg=197
"
" """ Funções e Classes
" hi jsArrowFunction ctermfg=blue
" hi jsFuncName ctermfg=227
" hi jsFuncCall ctermfg=227
" hi jsClassKeyword ctermfg=blue
" hi jsClassDefinition ctermfg=green
" hi jsGlobalObjects ctermfg=227
"
" """ const, let, var
" """ function, true, false, null,
" """ undefined e NaN
" hi jsStorageClass ctermfg=blue
" hi jsFunction ctermfg=blue
" hi jsBooleanTrue ctermfg=99
" hi jsBooleanFalse ctermfg=99
" hi jsNull ctermfg=99
" hi jsUndefined ctermfg=99
" hi jsNan ctermfg=99
"
" """ Números
" hi jsNumber ctermfg=157
"
" """ this, async e await
" hi jsThis ctermfg=197
" hi jsAsyncKeyword ctermfg=197
" hi jsForAwait ctermfg=197
"
" " Umas palavras especiais, por exemplo "console", "Array" etc
" hi jsGlobalObjects cterm=italic ctermfg=green
"
" source $HOME/.config/nvim/after/syntax/javascriptreact.vim
