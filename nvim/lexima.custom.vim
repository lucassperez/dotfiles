" Eu quero auto completar somente quando o caracter seguinte
" for ou um espaço/branco ou uma linha nova

" Primeiro desabilitamos o g:lexima#default_rules, presente no arquivo
" autoload/lexima.vim.
" Esse default_rules diz respeito a auto completar parentesis, colchetes,
" chaves e os mascadores de string no geral.
" A ideia é usar o atributo "at" pra especificar que depois do cursor,
" representado por \%#, tem que ter um espaço em branco/fim de linha (\s e \n).
" As regras de nova linha estão definidas em g:lexima#newline_rules, então foi
" desativado somente a "auto completação" dos símbolos mencionados.
" Note que nem tudo é perfeito, às vezes você quer que complete e às vezes não.
" Estou definido as regras que mais frequentemente são as que eu quero, pelo
" menos as que eu imagino.
" Como este plugin oferece esta customização fácil achei que era melhor fazer
" isso do que alterar o código dentro da pasta raiz, mesmo.
" Ele também vai autocompletar caso o próximo caracter seja um parentesis ou
" colchetes ou chaves, pois é muito comum abrir chaves dentro de chaves, ou
" Caracteres que podem ser os próximos que ele completa mesmo assim:
" Espaço/nova linha: \s e \n
" Fechamento de parenteses, colchetes e chaves: ), ], }, )
" Pontuações e "tag html": . , ! ? : ; / >

" TODO: Quero completar parentesis, colchetes e chaves caso o próximo
" caracter seja um caracter de string, isto é, aspas/apóstrofo/crase, mas não
" quero autocompletar outros caracteres de string nesse caso. Logo, tenho que
" adicionar ', ", ` etc só nos blocos de parentesis, colchetes e chaves.

let g:lexima_enable_basic_rules = 0
let g:lexima_enable_endwise_rules=0 " não colocar "end" sozinho

" Regras de parentesis
call lexima#add_rule({'char': '(', 'at': '\%#[\s\n)\]},\.!?:;</>]', 'input_after': ')'})
call lexima#add_rule({'char': '(', 'at': '\\\%#\s'})
call lexima#add_rule({'char': ')', 'at': '\%#)', 'leave': 1})
call lexima#add_rule({'char': '<BS>', 'at': '(\%#)', 'delete': 1})

" Regras dos colchetes
call lexima#add_rule({'char': '[', 'at': '\%#[\s\n)\]},\.!?:;</>]', 'input_after': ']'})
call lexima#add_rule({'char': '[', 'at': '\\\%#'})
call lexima#add_rule({'char': ']', 'at': '\%#]', 'leave': 1})
call lexima#add_rule({'char': '<BS>', 'at': '\[\%#\]', 'delete': 1})

" Regras das chaves
call lexima#add_rule({'char': '{', 'at': '\%#[\s\n)\]},\.!?:;</>]', 'input_after': '}'})
call lexima#add_rule({'char': '}', 'at': '\%#}', 'leave': 1})
call lexima#add_rule({'char': '<BS>', 'at': '{\%#}', 'delete': 1})

" Regras das mil coisas que normalmente representam strings
" TODO Arrumar essas regras de strings!
" Aspas
call lexima#add_rule({'char': '"', 'at': '\%#[\s\n)\]},\.!?:;</>]', 'input_after': '"'})
call lexima#add_rule({'char': '"', 'at': '\%#"', 'leave': 1})
call lexima#add_rule({'char': '"', 'at': '\\\%#'})
call lexima#add_rule({'char': '"', 'at': '^\s*\%#', 'filetype': 'vim'})
call lexima#add_rule({'char': '"', 'at': '\%#\s*$', 'filetype': 'vim'})
call lexima#add_rule({'char': '<BS>', 'at': '"\%#"', 'delete': 1})
call lexima#add_rule({'char': '"', 'at': '""\%#', 'input_after': '"""'})
call lexima#add_rule({'char': '"', 'at': '\%#"""', 'leave': 3})
call lexima#add_rule({'char': '<BS>', 'at': '"""\%#"""', 'input': '<BS><BS><BS>', 'delete': 3})

" Apóstrofos
call lexima#add_rule({'char': "'", 'at': '\%#[\s\n)\]},\.!?:;</>]', 'input_after': "'"})
call lexima#add_rule({'char': "'", 'at': '\%#''', 'leave': 1})
call lexima#add_rule({'char': "'", 'at': '\w\%#''\@!'})
call lexima#add_rule({'char': "'", 'at': '\\\%#'})
call lexima#add_rule({'char': "'", 'at': '\\\%#', 'leave': 1, 'filetype': ['vim', 'sh', 'csh', 'ruby', 'tcsh', 'zsh']})
call lexima#add_rule({'char': "'", 'filetype': ['haskell', 'lisp', 'clojure', 'ocaml', 'reason', 'scala', 'rust']})
call lexima#add_rule({'char': '<BS>', 'at': "'\\%#'", 'delete': 1})
call lexima#add_rule({'char': "'", 'at': "''\\%#", 'input_after': "'''"})
call lexima#add_rule({'char': "'", 'at': "\\%#'''", 'leave': 3})
call lexima#add_rule({'char': '<BS>', 'at': "'''\\%#'''", 'input': '<BS><BS><BS>', 'delete': 3})

" Crase
call lexima#add_rule({'char': '`', 'at': '\%#[\s\n)\]},\.!?:;</>]', 'input_after': '`'})
call lexima#add_rule({'char': '`', 'at': '\%#`', 'leave': 1})
call lexima#add_rule({'char': '<BS>', 'at': '`\%#`', 'delete': 1})
call lexima#add_rule({'char': '`', 'filetype': ['ocaml', 'reason']})
call lexima#add_rule({'char': '`', 'at': '``\%#', 'input_after': '```'})
call lexima#add_rule({'char': '`', 'at': '\%#```', 'leave': 3})
call lexima#add_rule({'char': '<BS>', 'at': '```\%#```', 'input': '<BS><BS><BS>', 'delete': 3})

