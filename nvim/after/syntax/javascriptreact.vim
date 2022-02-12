" " Utilizando os grupos definidos aqui:
" " https://github.com/MaxMEllon/vim-jsx-pretty
" " O vim-polyglot usa esses grupos, também
" " Lucas Perez, janeiro de 2020
" """"""""""""""""""""""""""""""""""""""""""""
"
" " Tag name são as tags normaizinhas tipo html, por exemplo:
" " <div></div>
" hi jsxTagName ctermfg=blue
"
" " Component Name são as tags com o nome do componente, por exemplo:
" " <NomeLegal></NomeLegal> ou <OutroNomeLegal/>
" " hi jsxComponentName ctermfg=160
" hi link jsxComponentName Type
"
" " jsxAttrib é a cor dada ao nome das propriedades passadas no componente,
" " por exemplo: <Componente propriedade={...} />
" hi jsxAttrib ctermfg=222
"
" " AttribKeyword eu não sei o que é e coloquei uma combinação
" " bizarra pra no dia que aparecer, eu lembrar e descobrir o que é
" hi jsxAttribKeyword ctermfg=yellow ctermbg=black
"
" " Essas são as chaves que começam o javascript no meio do html,
" " tipo <div>Nome: {value}</div>
" "                 ^     ^
" hi jsxBraces ctermfg=blue
