#!/bin/sh

conflict=''
staged=''
help=''
unknown_args=''
grep_pattern=''
diff_branch=''

while [ "$#" -gt 0 ]; do
  case "$1" in
    -c|--conflict)
      conflict=sim
      shift
      ;;
    -s|--staged)
      staged=sim
      shift
      ;;
    -S|--vstaged)
      staged=reverse_staged
      shift
      ;;
    -h|--help)
      help=sim
      break
      ;;
    -g|--grep)
      # TODO: Think about maybe passing grep options to grep?
      # Or at least make it possible to grep case insensitively?
      if [ -z "$2" ]; then
        echo 'An argument must be passed to -g or --grep option'
        exit 1
      fi
      grep_pattern="$2"
      grep_options=''
      shift 2
      ;;
    -v|--vgrep|-vg|-gv)
      # Grep can return only non match with -v flag (grep -v).
      # Since I did not implement passing arguments to grep, I made
      # this -v option here, too. The long name "vgrep" is kind of
      # random, but thought it sounded better than grepv
      if [ -z "$2" ]; then
        echo 'An argument must be passed to -v or --vgrep option'
        exit 1
      fi
      # TODO: Allow multiple -v without overriding the last pattern
      grep_pattern="$2"
      grep_options=-v
      shift 2
      ;;
    -b|--branch)
      if [ -z "$2" ]; then
        echo 'An argument must be passed to -b or --branch option'
        exit 1
      fi
      if `git branch | grep -wq "\<$2\>"`; then
        diff_branch="$2"
      else
        echo "Branch \e[1;31m$2\e[0m not found"
        exit 2
      fi
      shift 2
      ;;
    *)
      unknown_args="$1, $unknown_args"
      shift
      ;;
  esac
done

if [ -n "$unknown_args" -o -n "$help" ]; then
  [ -n "$unknown_args" ] && echo "Unknown option \`${unknown_args%%, }\`"
  echo 'Possible options:'
  echo '    -c  --conflict      Only lists files with git conflict markers (lines starting with <<<<<<<, ======= or >>>>>>>)'
  echo '    -s  --staged        Only lists files that are staged'
  echo '    -S --vstaged        Only lists files that are not staged'
  echo '    -g  --grep          Pass a pattern to grep over the result before opening files in vim'
  echo '    -v -gv -vg --vgrep  Pass a pattern to grep inverse matches (add -v to grep command)'
  echo '    -b  --branch        Pass a branch name to get the files changed between HEAD and that branch'
  echo 'If both conflict and staged options are passed, staged is ignored.'
  # If unknown_args is not empty but help is, I'm going to both
  # print this help message and open vim. Do I want this?
  # Might be weird.

  # This makes the program exit with non zero if help is not present,
  # which means unknown_args is present. But exit 0 if help is present.
  # So it exits 0 with --help, but exits non 0 with --dsadsa, for example.
  [ -n "$help" ] && exit || exit
fi

if [ -n "$conflict" -a -n "$staged" ]; then
  echo 'Both conflict and staged options passed, using only conflict.'
fi

# Git porcelain outputs some text and the beginning of the line.
# If it starts with R, it means the file was renamed, and it appears like this:
#   R old_name -> new_name
#   If awk finds a line that starts with R, it prints the 4th column, which is the new_name,
#   so it ignores the old_name and opens the correct new file.
# If it starts with D, it means it was deleted. Opening it in vimgit just shows an empty
#   file, so this ignores deleted files as well.
# If it starts with ??, it is either a new file or new directory. In this case,
#   git status --porcelain would only show the file name if directory already
#   exists, and if the directory is new, it would stop in the new directory.
#   Opening this in vim would open the directory (eg, Netrw buffer).
#   That is why the git ls-files command is added, to get only the new files.
#   If there is no ?? file, the git ls-files command returns empty, so we're fine.
# If it starts with anything else, it opens them.
git_porcelain_awk_command_with_new_files_complement() {
  local files=`\
    git status --porcelain | \
    awk '/^ ?R / { print $4; next} /^ ?D / { next } /^\?\?/ { next } { print $2 }'`

  echo "$files\n$(git ls-files --exclude-standard --others)"
}

files=''
if [ -n "$conflict" ]; then
  files=`git_porcelain_awk_command_with_new_files_complement | xargs grep -l '^[<=>]\{7\}'`
elif [ -n "$staged" ] && [ "$staged" = sim ]; then
  # Easier to use git diff than awk [[:blank:]] or something fancy
  files=`git diff --name-only --staged | awk '{print $1}'`
elif [ -n "$staged" ] && [ "$staged" = reverse_staged ]; then
  files=`git status --porcelain | awk '/^(\?\?| [A-CE-Z]|[A-Z][A-Z])/ { print $2 }'`
elif [ -n "$diff_branch" ]; then
  # TODO: Lidar com arquivos novos e renomeados aqui também.
  # Talvez usar git diff --name-status?
  files=`git diff --name-only "$diff_branch"`
  files="$files\n$(git ls-files --exclude-standard --others)"
else
  files=`git_porcelain_awk_command_with_new_files_complement`
fi

[ -z "$files" ] && exit

if [ -n "$grep_pattern" ]; then
  if [ -n "$grep_options" ]; then
    files=`echo $files | tr ' ' '\n' | grep "$grep_options" "$grep_pattern"`
  else
    files=`echo $files | tr ' ' '\n' | grep "$grep_pattern"`
  fi
fi

[ -z "$files" ] && exit

final_files=''
# Decided it is easier to store the toplevel like this and use the variables
# than using awk -v git_top_level=$(git rev-parse --show-toplevel) etc
toplevel=`git rev-parse --show-toplevel`
for f in `echo $files`; do
  final_files="$final_files\n$toplevel/$f"
done
final_files=`echo $final_files | sed '/^[[:space:]]*$/d'`

(
  cd $toplevel
  nvim `echo $final_files`
)
