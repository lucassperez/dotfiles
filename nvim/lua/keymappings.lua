local map = function(mode, key, result, noremap, silent)
  vim.api.nvim_set_keymap(mode, key, result, { noremap = noremap, silent = silent })
end

local noremap = function(mode, key, result, silent)
  map(mode, key, result, true, silent)
end

vim.g.mapleader = ' '

-- Atalho pra mostrar a quais grupos de sintaxe a palavra
-- debaixo do cursor pertence
noremap('n', '<leader>m', ':TSHighlightCapturesUnderCursor<CR>')

-- Abre um novo painel horizontal
noremap('n', '<leader>s', ':sp<CR>')
-- Abre um novo painel vertical
noremap('n', '<leader>v', ':vs<CR>')
-- Fecha o painel atual
noremap('n', '<leader>c', '<C-w>c')

map('n', 'ç', '$')
map('v', 'ç', '$h')

-- Abrir o último arquivo editado
noremap('n', '<leader>e', ':e#<CR>')
-- noremap('n', '<leader>e', '<C-^>')

-- Copiar para o clipboard do sistema o caminho do arquivo
noremap('n', '<leader>f', ':let @+ = expand("%")<CR>')

-- Acho que faz sentido Y copiar do cursor até o final da linha (ver :help Y)
noremap('n', 'Y', 'y$')

-- "zource" vim
noremap('n', '<leader>zv', ':so ~/.config/nvim/init.vim<CR>')

-- Não entrar no insert mode após usar leader + o/O
noremap('n', '<leader>o', 'o<C-c>')
noremap('n', '<leader>O', 'O<C-c>')

-- Deleta tudo que vem depois do primeiro sinal de igual da linha e
-- entra no insert mode
noremap('n', '<leader>C', '0f=lC<Space>')

-- Abrir links no firefox (quebra quando tem # :C)
noremap('n', 'gx', ':!firefox <C-r><C-a><CR>')

-- Buffer anterior
noremap('n', '<leader>q', ':bprevious<CR>')
-- Próximo buffer
noremap('n', '<leader>w', ':bnext<CR>')
-- Fecha o buffer atual
noremap('n', '<leader>d', ':bdelete<CR>')

-- Mudar de painéis segurando Control
noremap('n', '<C-h>', '<C-w>h')
noremap('n', '<C-j>', '<C-w>j')
noremap('n', '<C-k>', '<C-w>k')
noremap('n', '<C-l>', '<C-w>l')

-- Coisas do fzf
noremap('n', '<C-p>', ':GFiles<CR>')
noremap('n', '<C-f>', ':Ag<CR>')
noremap('n', '<leader>p', ':Files<CR>')
noremap('n', '<leader>h', ':History<CR>')

-- Copiar para o clipboard
noremap('v', '<leader>y', '"+y')
noremap('n', '<leader>y', '"+y')
noremap('n', '<leader>Y', '"+yg_')

-- Colar do clipboard
-- Conflito com as minhas configs do fzf
-- noremap('n', '<leader>p', '"+p')
-- noremap('n', '<leader>P', '"+P')
-- noremap('v', '<leader>p', '"+p')
-- noremap('v', '<leader>P', '"+P')

-- Mudar a indentaçãõ continuamente
-- https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc
-- Modo visual
noremap('v', '<', '<gv')
noremap('v', '>', '>gv')
noremap('v', '<Tab>', '>gv')
noremap('v', '<S-Tab>', '<gv')
-- Modo normal
noremap('n', '>', '>>')
noremap('n', '<', '<<')

-- Mover blocos de texto
---- Visual mode com J e K e <C-j> e <C-k>
noremap('v', 'J', ":m '>+1<CR>gv=gv")
noremap('v', 'K', ":m '<-2<CR>gv=gv")
noremap('v', '<C-j>', ":m '>+1<CR>gv=gv")
noremap('v', '<C-k>', ":m '<-2<CR>gv=gv")
---- Insert e normal modes com <C-j> e <C-k>
noremap('i', '<C-j>', '<C-c>:m .+1<CR>==i')
noremap('i', '<C-k>', '<C-c>:m .-2<CR>==i')

-- Mudar o tamanho dos painéis
noremap('n', '<C-Down>', ':resize -3<CR>')
noremap('n', '<C-Up>', ':resize +3<CR>')
noremap('n', '<C-Left>', ':vertical resize -5<CR>')
noremap('n', '<C-Right>', ':vertical resize +5<CR>')

-- Control + Del no insert mode
-- Note que pra apagar pra trás, Control + w funciona
noremap('i', '<C-Del>', '<C-o>de')

-- Colocar 3 (ou 6) crases, porque ninguém merece essa porcaria
noremap('n', '<leader>ç', 'i```<CR>```<CR><C-c>2kA')

-- shebang pra shell script
noremap('n', ',sh', 'i#!/bin/sh<CR><C-c>')
-- tenho andado escrevendo muito "binding.pry", então...
noremap('n', ',bp', 'obinding.pry<C-c>')

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

-- linter all
noremap('n', '<leader>rua', ":lua runLinter {}<CR>")
-- linter this file
noremap('n', '<leader>ruf', ":lua runLinter { cur_file = true }<CR>")

-- test all
noremap('n', '<leader>ra', ":lua runAutomatedTest {}<CR>")
-- test this file
noremap('n', '<leader>rs', ":lua runAutomatedTest { cur_file = true }<CR>")
-- test this file this line
noremap('n', '<leader>rn', ":lua runAutomatedTest { cur_file = true, cur_line = true }<CR>")
-- test this file this line
noremap('n', '<leader>rd', ":lua runAutomatedTest { cur_dir = true }<CR>")

-- Run last command
noremap('n', '<leader>rl', ':call VtrSendCommand("!!")<CR>')

-- Executa o arquivo como um script a depender do seu "filetype"
-- Ver o script para detalhes
noremap('n', '<leader>rr', ':luafile ~/.config/nvim/lua/filetype-tmux-runners/execute-script.lua<CR>')

-- Muda entre cores term e gui
noremap('n', '<leader>i', ':set termguicolors!<CR>')

--- Snippets ---
noremap('n', ',html', ':-1read $HOME/.config/nvim/snippets/html5<CR>6jf>l')
noremap('n', ',rfce', ":-1read $HOME/.config/nvim/snippets/reactfunctcomp<CR>:%s/$1/=expand('%:t:r')/g<CR>5k")
-- nnoremap ,clg :-1read $HOME/.config/nvim/snippets/console.log<CR>==f)i
vim.cmd('iabbrev clg, console.log')
-- ainda ta ruim esse do console.log ):
noremap('n', ',rspec', ':-1read $HOME/.config/nvim/snippets/rubyspec<CR>2j6l')
noremap('n', ',stl', ':-1read $HOME/.config/nvim/snippets/styledcomps<CR>j')
-- noremap('n', ',vcomp', ":-1read $HOME/.config/nvim/snippets/vuecomp<CR>:%s/$1/=expand('%:t:r')/g<CR>0")
-- noremap('n', ',exm', ":-1read $HOME/.config/nvim/snippets/elixirmodule<CR>:%s/$1/=expand('%:t:r')/g<CR>jS")
vim.cmd('iabbrev dfm, defmodule')

-- Buscar por uma sequência de <<<, === ou >>>, pra usar quando tem conflitos
-- no git
noremap('n', '<leader>/', '/\\(<\\|=\\|>\\)\\{7\\}<CR>')

-- Colocar o shebang #!/bin/sh
noremap('n', ',sh', 'ggI#!/bin/sh<CR><C-c>:set ft=sh<CR>')

-- Colocar um ponto e vírgula no final da linha
noremap('n', '<leader>;', 'A;<C-c>')

-- Abrir um programa com o programa padrão para aquele tipo de arquivo
noremap('n', '<leader>x', ':!xdg-open %<CR><CR>')

-- "Zoom" na split atual
noremap('n', '<leader>-', ':wincmd _<CR>:wincmd |<CR>')
-- Deixar as splits o mais parecidas possível
noremap('n', '<leader>=', ':wincmd =<CR>')
