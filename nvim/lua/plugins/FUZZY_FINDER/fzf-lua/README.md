1. Seria muito bom ter como ver as que cada comando pode receber.
   Por exemplo, o `jump_to_single_result` eu descobri olhando o código.
   O telescope tem uma doc muito boa, com todos os argumentos de todos
   os comandos listados e explicados, no estilo da doc do nvim.

2. Por que no comando FzfLua buffers eu não consigo mexer o cursor pelas opções?
   Dessa maneira também não consigo ver o preview. Esquisito.

3. O comando FzfLua git_files poderia ter um jeito de mostrar arquivos que ainda
   estão untracked pelo git. O comando
   git -C `git rev-parse --show-toplevel` ls-files --exclude-standard --cached --others
   funciona perfeitamente na linha de comando, mas não funciona se passar isso
   como cmd para o FzfLua, volta vazio, não mostra __nenhum__ arquivo ):

Vendo o código fonte de fzf-lua/providers/lsp.lua, achei as seguintes opções:

    jump_to_single_result;
    ignore_current_line
    cwd_only (?)
    current_buffer_only
    filter (?)
