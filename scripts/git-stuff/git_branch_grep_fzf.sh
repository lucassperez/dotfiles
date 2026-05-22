#!/bin/sh

imprimir_mensagem_mudando_de_branch() {
  printf "Mudando para \e[1m$1\e[0m\n"
}

if [ "$#" -eq 0 ]; then
  branches="`git branch`"
  count=`printf "$branches\n" | wc -l | tr -d '[[:blank:]]'`
  selected=`printf "$branches" | fzf --height=$(expr 2 + $count)`

  if [ -z "$selected" ]; then
    exit 3
  fi

  selected=`printf "$selected" | sed -E 's/^[*+]?[[:blank:]]*//'`
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
      printf 'Basicamente, recebe um padrão e busca uma branch git que casa com esse\n'
      printf 'padrão. Caso exista mais de uma, joga as possíveis branches no fzf.\n'
      printf 'A busca com o padrão ignora maiúsculas e minúsculas (grep -i).\n'
      printf 'Caso nenhum padrão seja passado, passa todas as branches direto para o fzf.\n'
      printf 'Caso duas branches casem com o padrão mas uma delas for a branch atual,\n'
      printf 'mudamos direto para a outra branch.'
      printf
      printf 'Também é possível passar algumas opções para alterar a funcionalidade:\n'
      printf
      printf '-           Ir para a última branch (git checkout -)\n'
      printf '.           Executa git checkout .\n'
      printf '-b          Criar e mudar para a branch (git checkout -b)\n'
      printf '-h --help   Mostra esse texto de ajuda\n'
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
  printf 'Mudando para a última branch\n'
  git checkout -
  exit
fi

if [ -n "$create_and_checkout" ]; then
  printf "Criando e mudando para \e[1m$create_and_checkout\e[0m\n"
  git checkout -b "$create_and_checkout"
  exit
fi

if [ -n "$checkout_dot" ]; then
  printf 'Executando `git checkout .`\n'
  git checkout .
  exit
fi

# TODO: Deixei grep -i pra ser case insensitive. Pensar sobre.
partial=`git branch | grep -i "$grep_pattern"`

if [ -z "$partial" ]; then
  printf "Nenhuma branch encontrada para o grep com $grep_pattern\n"
  exit 10
fi

count=`printf "%s\n" "$partial" | wc -l`
if [ "$count" -eq 2 ] && printf "$partial" | grep -q '^*'; then
  # Esse sed dá match na branch que não é a atual
  # e tira os espaços do começo que houverem.
  b=`printf "$partial" | sed -n 's/^[^*]\s*//p'`
  printf "Duas branches encontradas, mas uma era a atual.\nTrocando para a outra: \e[1m$b\e[0m\n"
  git checkout `printf "$partial" | grep -v '^*'`
  exit
elif [ "$count" -gt 1 ]; then
  printf "Resultado com mais de uma branch encontrada para o grep com $grep_pattern\n"
  selected=`printf "$partial" | fzf --height=$(expr 2 + $count)`

  if [ -z "$selected" ]; then
    exit 11
  fi

  selected=`printf "$selected" | tr -d '*' | tr -d '[[:blank:]]'`
  imprimir_mensagem_mudando_de_branch "$selected"
  git checkout `printf $selected | sed 's/^\*\?\s*//'`
  exit
fi

b=`printf "$partial" | tr -d '*' | tr -d '[[:blank:]]'`
imprimir_mensagem_mudando_de_branch "$b"
git checkout "$b"
