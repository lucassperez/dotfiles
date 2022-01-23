local map = function(mode, key, result, noremap, silent)
  vim.api.nvim_set_keymap(mode, key, result, { noremap = noremap, silent = silent })
end

local noremap = function(mode, key, result, silent)
  map(mode, key, result, true, silent)
end

vim.g.mapleader = ' '

-- Normally C-c already does this, but after installing LSP, the text box
-- containing completions would not properly disappear when I C-c out of insert
-- mode sometimes, which did not happen with ESC.
map('i', '<C-c>', '<Esc>')

-- Fingir que tenho dois pontos ao laod do L pra ir me acostumando aos poucos
noremap('n', 'Ç', ':')
noremap('v', 'Ç', ':')

-- Atalho pra mostrar a quais grupos de sintaxe a palavra
-- debaixo do cursor pertence
noremap('n', '<leader>m', ':TSHighlightCapturesUnderCursor<CR>')

-- Novos paineis (horizontal e vertical) e fechar o atual
noremap('n', '<leader>s', ':sp<CR>')
noremap('n', '<leader>v', ':vs<CR>')
noremap('n', '<leader>c', '<C-w>c')

-- Se tem ç, tem que usar
map('n', 'ç', '$')
map('v', 'ç', '$h')

-- Abrir o último arquivo editado
noremap('n', '<leader><space>', ':e#<CR>')

-- Copiar para o clipboard do sistema o caminho do arquivo
noremap('n', '<leader>f', ':let @+ = expand("%")<CR>')

-- Acho que faz sentido Y copiar do cursor até o final da linha (ver :help Y)
noremap('n', 'Y', 'y$')

-- "zource" vim
noremap('n', '<leader>zv', ':so ~/.config/nvim/init.vim<CR>')
-- "zource" lua
noremap('n', '<leader>zl', ':luafile ~/.config/nvim/lua/init.lua<CR>')

-- Não entrar no insert mode após usar leader + o/O
noremap('n', '<leader>o', 'o<C-c>')
noremap('n', '<leader>O', 'O<C-c>')

-- Abrir links no firefox (quebra quando tem # :C)
noremap('n', 'gx', ':!firefox <C-r><C-a><CR>')

-- Ir para o buffer anterior/próximo e fechar o atual
noremap('n', '<leader>q', ':bprevious<CR>')
noremap('n', '<leader>w', ':bnext<CR>')
noremap('n', '<leader>d', ':bdelete<CR>')

-- Mudar de painéis segurando Control
-- noremap('n', '<C-h>', '<C-w>h')
-- noremap('n', '<C-j>', '<C-w>j')
-- noremap('n', '<C-k>', '<C-w>k')
-- noremap('n', '<C-l>', '<C-w>l')

-- Coisas do fzf
noremap('n', '<C-p>', ':GFiles<CR>')
noremap('n', '<C-f>', ':Ag<CR>')
noremap('n', '<leader>p', ':Files<CR>')
noremap('n', '<leader>h', ':History<CR>')

-- Copiar para o clipboard
noremap('v', '<leader>y', '"+y')
noremap('n', '<leader>y', '"+y')
noremap('n', '<leader>Y', '"+yg_')

-- Mudar a indentaçãõ continuamente
-- https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc
-- Modo visual
noremap('v', '<', '<gv')
noremap('v', '>', '>gv')
-- Modo normal
noremap('n', '>', '>>')
noremap('n', '<', '<<')

-- Mover blocos de texto
-- TODO: Fazer um map para a mesma coisa no normal mode
noremap('v', '<C-j>', ":m '>+1<CR>gv=gv")
noremap('v', '<C-k>', ":m '<-2<CR>gv=gv")

-- Mudar o tamanho dos painéis
noremap('n', '<C-Down>', ':resize -3<CR>')
noremap('n', '<C-Up>', ':resize +3<CR>')
noremap('n', '<C-Left>', ':vertical resize -5<CR>')
noremap('n', '<C-Right>', ':vertical resize +5<CR>')

-- Control + Del no insert mode
-- Note que pra apagar pra trás, Control + w funciona
noremap('i', '<C-Del>', '<C-o>de')

-- Colocar 3 (ou 6) crases
noremap('n', '<leader>ç', 'i```<CR>```<CR><C-c>2kA')

-- Tenho andado escrevendo muito "binding.pry", então...
-- noremap('n', ',bp', 'obinding.pry<C-c>')
noremap('n', ',bp', ':lua writeDebuggerBreakpoint()<CR>')
noremap('n', ',BP', ':lua writeDebuggerBreakpoint(true)<CR>')
noremap('n', ',Bp', ':lua writeDebuggerBreakpoint(true)<CR>')

-- É brincadeira que :noh<CR> não vem por padrão em algum lugar, viu...
noremap('n', '<Esc>', ':noh<CR>')

-- Rodar linter e testes automatizados de dentro do vim (tem que ter um "runner" setado antes)
-- Dependendo do tipo de arquivo, será feito algo diferente.
-- Linguagens configuradas:
-- - Ruby (rubocop e rspec)
-- - Elixir (credo e test)
-- Mnemônicos: rubocop all (rua), rubocop file (ruf),
--             rspec all (ra), rspec (rs), rspec near (rn), rspec directory (rd),
--             attach (<leader>a)

-- Setar um runner pro Vim Tmux Runner
noremap('n', '<leader>a', ':VtrAttachToPane<CR>')
noremap('n', '<leader><C-d>', ':VtrSendCtrlD<CR>')
noremap('n', '<leader><C-c>', ':VtrSendCtrlC<CR>')

-- linter all & linter this file
noremap('n', '<leader>rua', ':lua runLinter {}<CR>')
noremap('n', '<leader>ruf', ':lua runLinter { cur_file = true }<CR>')

-- test all, test this file, test this file this line &  test this directory
noremap('n', '<leader>ra', ':lua runAutomatedTest {}<CR>')
noremap('n', '<leader>rs', ':lua runAutomatedTest { cur_file = true }<CR>')
noremap('n', '<leader>rn', ":lua runAutomatedTest { cur_file = true, cur_line = true }<CR>")
noremap('n', '<leader>rd', ':lua runAutomatedTest { cur_dir = true }<CR>')

-- Pegando os arquivos no diff com a main/master e executando rspec/rubocop
-- Mmenônicos: rspec-main (rm) e rubocop-main (rum)
noremap('n', '<leader>rm', ':lua fromGit.genericTest()<CR>')
noremap('n', '<leader>rum', ':lua fromGit.genericLinter()<CR>')

-- Run last command executado no painel "anexado"
noremap('n', '<leader>rl', ':call VtrSendCommand("!!")<CR>')

-- Executa o arquivo como um script a depender do seu "filetype"
-- Ver o script para detalhes
noremap('n', '<leader>rr', ':lua executeFileAsScript()<CR>', true) -- silent = true

--- Snippets ---
noremap('n', ',html', ':read $HOME/.config/nvim/snippets/html5<CR>i<Backspace><C-c>6jf>l')
noremap('n', ',rfce', ":read $HOME/.config/nvim/snippets/reactfunctcomp<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>5k")
noremap('n', ',cl', ':read $HOME/.config/nvim/snippets/console.log<CR>i<Backspace><C-c>==f)i')
noremap('n', ',rspec', ':read $HOME/.config/nvim/snippets/rubyspec<CR>i<Backspace><C-c>2j6l')
noremap('n', ',stl', ':read $HOME/.config/nvim/snippets/styledcomps<CR>i<Backspace><C-c>j')
-- noremap('n', ',vcomp', ":read $HOME/.config/nvim/snippets/vuecomp<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>0")
-- noremap('n', ',exm', ":read $HOME/.config/nvim/snippets/elixirmodule<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>jS")
noremap('n', ',go', ':read $HOME/.config/nvim/snippets/gomain<CR>i<Backspace><C-c>5jS')

-- Buscar por uma sequência de <<<<<<<, ======= ou >>>>>>>
-- Pra usar quando tem conflitos no git
noremap('n', '<leader>/', '/\\(<\\|=\\|>\\)\\{7\\}<CR>')

-- Colocar o shebang #!/bin/sh
noremap('n', ',sh', 'ggI#!/bin/sh<CR><CR><C-c>')
-- Colocar o shebang #!/bin/sh e dar permissão de execução ao arquivo (o silent = true não ta funcionando?)
noremap('n', ',SH', 'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>', true)
noremap('n', ',Sh', 'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>', true)

-- Colocar um ponto e vírgula no final da linha
noremap('n', '<leader>;', 'A;<C-c>')

-- Abrir um programa com o programa padrão para aquele tipo de arquivo
noremap('n', '<leader>x', ':!xdg-open %<CR><CR>')

-- "Zoom" na split atual e deixar as splits o mais parecidas possível
noremap('n', '<leader>-', ':wincmd _<CR>:wincmd |<CR>')
noremap('n', '<leader>=', ':wincmd =<CR>')

-- Send current line (or lines in visual mode) to attached tmux pane
noremap('n', '<leader>R', ':lua sendLinesToTmux("normal")<CR>')
noremap('v', '<leader>R', ':lua sendLinesToTmux("visual")<CR>')

-- Tries to find the test file of current file or vice versa.
-- Works well with elixir and its organized and predictable paths.
noremap('n', '<leader>e', ':lua toggleBetweenTestAndFile()<CR>')
