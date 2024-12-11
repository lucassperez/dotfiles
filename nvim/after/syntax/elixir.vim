" Com tree sitter, só quero os private defines
match elixirPrivateDefine /\<def\(guard\|macro\)\?p\>/
"hi elixirPrivateDefine ctermfg=red guifg=#e85858
hi elixirPrivateDefine ctermfg=red guifg=#e58183

" " Utilizando os grupos definidos em:
" " https://github.com/elixir-editors/vim-elixir
" " O vim-polyglot usa os grupos acima
" " Lucas Perez, janeiro de 2021
" """"""""""""""""""""""""""""""""""""""""""""
" " Tabela de cores:
" " https://jonasjacek.github.io/colors/
" """"""""""""""""""""""""""""""""""""""""""""

" " Marcar and/or/not com as mesmas cores de def, end etc
" syn match elixirKeyword '\(\.\)\@<!\<\(and\|or\|not\)\>:\@!'

" " Estilo para true, false e nil
" hi link elixirBoolean Boolean

" " Estilo dos Atoms
" " hi elixirAtom ctermfg=99 guifg=#875fff
" hi elixirAtom ctermfg=99 guifg=#8787ff

" " Estilo para o nome da função no momento que é declarada
" hi link elixirFunctionDeclaration Function

" " Estilo para strings
" " Cor número 172 ou 100 para as strings? 209 = salmão1!
" hi link elixirStringDelimiter elixirString

" " Estilo para char lists # 118?
" hi elixirCharList          ctermfg=118 guifg=#87ff00
" hi elixirCharListDelimiter ctermfg=118 guifg=#87ff00

" " Cores dos números
" hi elixirNumber ctermfg=157 guifg=#afffaf

" " Fazer os delimiters darem match com a string também seria uma solução, mas
" " talvez um pouco agressiva. Esse regex aparentemente faria o trabalho de
" " incluir no grupo "elixirString" desde a abertura das aspas/dos apóstrofos até
" " onde se fecham, incluindo tudo no meio.
" " match elixirString /".\+"\|'.\+'/

" " Cores de coisas como def, defmodule, defp etc
" " Vale notar que existem os grupos elixirDefine e elixirPrivateDefine, se quiser
" " colocar cores diferentes para eles
" " hi Define ctermfg=magenta guifg=#ca9ee6
" hi link Define Include
" hi elixirPrivateDefine ctermfg=red guifg=#ef2929

" " Algumas coisas no meio do regex, tipo barras, sinal de +
" hi elixirRegexEscapePunctuation ctermfg=red guifg=#ef2929

" " Colocar corzinha em \\ e ->
" " Será que eu deveria incluir o underline _ ?
" syn match elixirCustomOutros /->\||>\|<>\|<-/
" hi elixirCustomOutros cterm=bold gui=bold

" " hi elixirDocString ctermfg=211 guifg=#e57ba0
" " hi elixirDocStringDelimiter ctermfg=211 guifg=#e57ba0
" hi link elixirDocString Comment
" hi link elixirDocStringDelimiter Comment

" " __FILE__ __DIR__ __MODULE__ __ENV__ __CALLER__ __STACKTRACE__
" hi elixirPseudoVariable ctermfg=197 guifg=#ff005f

" hi link elixirExUnitAssert Function

" " Os caracteres de interpolação de string: #{}
" " hi elixirInterpolationDelimiter ctermfg=99 guifg=#875fff
" hi elixirInterpolationDelimiter ctermfg=99 guifg=#8787ff

" hi link elixirSigil elixirAtom
" " hi link elixirSigilDelimiter elixirAtom
