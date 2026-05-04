#!/bin/sh

imprimir_mensagem_mudando_de_branch() {
  echo "Mudando para \e[1m$1\e[0m"
}

if [ "$#" -eq 0 ]; then
  branches="`git branch`"
  count=`echo "$branches" | wc -l | tr -d '[[:blank:]]'`
  selected=`echo "$branches" | fzf --height=$(expr 2 + $count)`
  echo $selected

  if [ -z "$selected" ]; then
    exit 3
  fi

  selected=`echo "$selected" | sed -E 's/^[*+]?[[:blank:]]*//'`
  imprimir_mensagem_mudando_de_branch "$selected"
  git checkout "$selected"
  exit
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    -)
      checkout_last=yes
      ;;
    .)
      checkout_dot=yes
      ;;
    -b)
      create_and_checkout="$2"
      shift
      ;;
    -h|--help)
      echo 'Basicamente, recebe um padrão e busca uma branch git que casa com esse'
      echo 'padrão. Caso exista mais de uma, joga as possíveis branches no fzf.'
      echo 'A busca com o padrão ignora maiúsculas e minúsculas (grep -i).'
      echo 'Caso nenhum padrão seja passado, passa todas as branches direto para o fzf.'
      echo 'Caso duas branches casem com o padrão mas uma delas for a branch atual,'
      echo 'mudamos direto para a outra branch.'
      echo
      echo 'Também é possível passar algumas opções para alterar a funcionalidade:'
      echo
      echo '-           Ir para a última branch (git checkout -)'
      echo '.           Executa git checkout .'
      echo '-b          Criar e mudar para a branch (git checkout -b)'
      echo '-h --help   Mostra esse texto de ajuda'
      exit
      ;;
    *)
      if [ -z "$grep_pattern" ]; then
        grep_pattern="$1"
      fi
  esac
  shift
done

if [ -n "$checkout_last" ]; then
  echo Mudando para a última branch
  git checkout -
  exit
fi

if [ -n "$create_and_checkout" ]; then
  echo "Criando e mudando para \e[1m$create_and_checkout\e[0m"
  git checkout -b "$create_and_checkout"
  exit
fi

if [ -n "$checkout_dot" ]; then
  echo 'Executando `git checkout .`'
  git checkout .
  exit
fi

# TODO: Deixei grep -i pra ser case insensitive. Pensar sobre.
partial=`git branch | grep -i $grep_pattern`

if [ -z "$partial" ]; then
  echo Nenhuma branch encontrada para o grep com "$grep_pattern"
  exit 10
fi

count=`echo "$partial" | wc -l`
if [ "$count" -eq 2 ] && echo "$partial" | grep -q '^*'; then
  # Esse sed dá match na branch que não é a atual
  # e tira os espaços do começo que houverem.
  b=`echo "$partial" | sed -n 's/^[^*]\s*//p'`
  echo "Duas branches encontradas, mas uma era a atual.\nTrocando para a outra: \e[1m$b\e[0m"
  git checkout `echo "$partial" | grep -v '^*'`
  exit
elif [ "$count" -gt 1 ]; then
  echo Resultado com mais de uma branch encontrada para o grep com "$grep_pattern"
  selected=`echo "$partial" | fzf --height=$(expr 2 + $count)`

  if [ -z "$selected" ]; then
    exit 11
  fi

  selected=`echo "$selected" | tr -d '*' | tr -d '[[:blank:]]'`
  imprimir_mensagem_mudando_de_branch "$selected"
  git checkout `echo $selected | sed 's/^\*\?\s*//'`
  exit
fi

b=`echo "$partial" | tr -d '*' | tr -d '[[:blank:]]'`
imprimir_mensagem_mudando_de_branch "$b"
git checkout "$b"
