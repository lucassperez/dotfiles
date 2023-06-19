local map = function(mode, key, command, opts)
  vim.keymap.set(mode, key, command, opts)
end

local noremap = function(mode, key, command, opts)
  if opts then opts.noremap = true end
  vim.keymap.set(mode, key, command, opts)
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Go to command mode without using shift
noremap({ 'n', 'v' }, ';', ':')

-- Map some commands do not copy empty line to register.
-- Also does not copy line made of only whitespaces.
-- Do I really want this? :thinking:

local function mapWhitespaceLine(command)
  -- TODO find a way to make this work in visual mode.
  -- How to get selection area?
  vim.keymap.set('n', command, function()
    if vim.api.nvim_get_current_line():match('^%s*$') then
      return '"_' .. command
    end
    return command
  end, { expr = true })
end

mapWhitespaceLine('dd')
mapWhitespaceLine('cc')
mapWhitespaceLine('S')

-- Am I'm going too far?
local function mapWhitespaceCharacter(command)
  -- Would be nice to make this work for things like d + motion,
  -- but looks too complicated. Simple 'o' mode is not quite right.
  vim.keymap.set('n', command, function()
    local line = vim.api.nvim_get_current_line()
    local column = 1 + vim.api.nvim_win_get_cursor(0)[2]
    local char_under_cursor = line:sub(column, column)

    if char_under_cursor:match('%s') then
      return '"_'..command
    end
    return command
  end, { expr = true })
end

mapWhitespaceCharacter('s')
mapWhitespaceCharacter('x')

-- Cansei de fazer isso aqui sem querer
-- Mas isso fica deixando os macros esquisitos de começar e principalmente
-- acabar, porque quando aperto q o vim fica esperando pra saber se era só
-- q mesmo ou se vai ser q:
noremap('n', 'q:', ':q')

-- Normally C-c already does this, but after installing LSP, the text box
-- containing completions would sometimes not properly disappear when I C-c out
-- of insert mode, which did not happen with Esc.
map('i', '<C-c>', '<Esc>')

-- Novos paineis (horizontal e vertical) e fechar o atual
noremap('n', '<leader>s', ':sp<CR>')
noremap('n', '<leader>v', ':vs<CR>')
noremap('n', '<leader>c', '<C-w>c')

-- Salvar e fechar tudo, eita.
-- Writes and quits from everything, omg!
-- Files without a name are not saved.
noremap('n', '<C-q>', function()
  for _, buf in pairs(vim.fn.getbufinfo()) do
    -- If it has a name, is listed and has changes
    if buf.name ~= '' and buf.listed ~= 0 and buf.changed ~= 0 then
      vim.cmd('b '..buf.bufnr)
      vim.cmd('w')
    end
  end
  vim.cmd('qa!')
end)

-- I used to use ç to go to the end of line, but removed it
-- to get used to using H and L to go forth and back on non ABNT2 keyboards.
-- Basically L goes to the end and H goes to the start of lines.
-- In visual mode, L does not get the "new line" at the end, and H does
-- not go to the first column, but instead to the first character in the line.
map({ 'n', 'o', }, 'L', '$')
map('v', 'L', '$h')
map({ 'n', 'v', 'o', }, 'H', '^')

-- Abrir o último arquivo editado
-- C-6 already does this, see :h CTRL-6 and :h alternate-file
-- noremap('n', '<leader><Space>', ':e#<CR>')
noremap('n', '<leader><Space>', '<C-6>')

-- Copiar para o clipboard do sistema o caminho do arquivo
noremap('n', '<leader>f', ':let @+ = expand("%:p")<CR>')

-- Acho que faz sentido Y copiar do cursor até o final da linha (ver :help Y)
-- In neovim, this is mapped automatically. It made sense in vim though.
-- noremap('n', 'Y', 'y$')

-- Não entrar no insert mode após usar leader + o/O
noremap('n', '<leader>o', 'o<C-c>')
noremap('n', '<leader>O', 'O<C-c>')

-- Abrir links no firefox (quebra quando tem # :C)
-- O plugin nvim-various-textobjects ta fazendo isso já e de forma
-- mais inteligente, inlcusive tratando quando tem # na url, e
-- usando xdg-open pra abrir o site com o aplicativo padrão.
-- noremap('n', 'gx', ':!firefox <C-r><C-a><CR>')

-- Ir para o buffer anterior/próximo e fechar o atual
-- O plugin barbar.vim estaria sobrescrevendo esses mappings de qualquer forma
noremap('n', '<leader>q', ':bprevious<CR>')
noremap('n', '<leader>w', ':bnext<CR>')
noremap('n', '<leader>d', ':bdelete<CR>')
noremap('n', '<A-q>', ':bprevious<CR>')
noremap('n', '<A-w>', ':bnext<CR>')

-- Tab management maps using similar logic to buffer mappings above
-- Vim actually has some built-ins!
-- gt go to next tab (like tabnext)
-- gT go to previous tab (like tabprevious)
-- {count}gt go to tab number {count} (nice!)
-- g<Tab> go to last accessed tab (nice!)
noremap('n', '<leader>tn', ':$tabnew %<CR>')
noremap('n', '<leader>tq', ':tabprevious<CR>')
noremap('n', '<leader>tw', ':tabnext<CR>')
noremap('n', '<A-t>', ':$tabnew %<CR>')
noremap('n', '<A-a>', ':tabprevious<CR>')
noremap('n', '<A-s>', ':tabnext<CR>')
noremap('n', '<leader>td', ':tabclose<CR>')
noremap('n', '<leader>tc', ':tabclose<CR>')

-- Mudar de painéis segurando Control
-- O plugin tmux.nvim está fazendo isso
-- noremap('n', '<C-h>', '<C-w>h')
-- noremap('n', '<C-j>', '<C-w>j')
-- noremap('n', '<C-k>', '<C-w>k')
-- noremap('n', '<C-l>', '<C-w>l')

-- Copiar para o clipboard do sistema
-- Yank
noremap({ 'n', 'v' }, '<leader>y', '"+y')
noremap('n', '<leader>Y', '"+yg_')
-- Delete
-- This is already for buffer delete!
-- noremap({ 'n', 'v' }, '<leader>d', '"+d')
noremap('n', '<leader>D', '"+dg_')

-- Mudar a indentação continuamente
-- https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc
---- I don't know about this, but oh well
-- Modo visual
noremap('v', '<', '<gv')
noremap('v', '>', '>gv')
-- Modo normal
noremap('n', '>', '>>')
noremap('n', '<', '<<')

-- Mover blocos de texto
noremap('v', '<M-j>', ":m '>+1<CR>gv=gv")
noremap('v', '<M-k>', ":m '<-2<CR>gv=gv")
noremap('n', '<M-j>', ':m .+1<CR>==')
noremap('n', '<M-k>', ':m .-2<CR>==')

-- Mudar o tamanho dos painéis
noremap('n', '<C-Down>', ':resize -3<CR>')
noremap('n', '<C-Up>', ':resize +3<CR>')
noremap('n', '<C-Left>', ':vertical resize -5<CR>')
noremap('n', '<C-Right>', ':vertical resize +5<CR>')

-- Control + Del no insert mode
-- Note que pra apagar pra trás, Control + w funciona
noremap('i', '<C-Del>', '<C-o>de')

-- Se receber true como argumento, essa função escreve na linha anterior. A
-- ideia é como os comandos `o` e `O`, só que pra um debugger (binding.pry no
-- ruby, IEx.pry no elixir). Se segurar shift em algum momento, manda pra linha
-- de cima (recebe true como argumento), do contrário, manda pra linha de baixo.
noremap('n', ',bp', function() WriteDebuggerBreakpoint() end, { silent = true })
noremap('n', ',BP', function() WriteDebuggerBreakpoint(true) end, { silent = true })
noremap('n', ',Bp', function() WriteDebuggerBreakpoint(true) end, { silent = true })
noremap('n', ',bP', function() WriteDebuggerBreakpoint(true) end, { silent = true })

local elixir_pipe_pry = [[|> fn x -><CR>require IEx; IEx.pry()<CR>x<CR>end.()]]
noremap('n', ',,bp', 'o'..elixir_pipe_pry..'<C-c>')
noremap('n', ',,BP', 'O'..elixir_pipe_pry..'<C-c>')
noremap('n', ',,Bp', 'O'..elixir_pipe_pry..'<C-c>')
noremap('n', ',,bP', 'O'..elixir_pipe_pry..'<C-c>')

noremap('n', ',io', 'oIO.inspect(, label: "@@")<C-c>F,')
noremap('n', ',IO', 'OIO.inspect(, label: "@@")<C-c>F,')
noremap('n', ',Io', 'OIO.inspect(, label: "@@")<C-c>F,')
noremap('n', ',iO', 'OIO.inspect(, label: "@@")<C-c>F,')

noremap('n', ',,io', 'o|> IO.inspect(label: "@@")<C-c>')
noremap('n', ',,IO', 'O|> IO.inspect(label: "@@")<C-c>')
noremap('n', ',,Io', 'O|> IO.inspect(label: "@@")<C-c>')
noremap('n', ',,iO', 'O|> IO.inspect(label: "@@")<C-c>')

-- É brincadeira que :noh<CR> não vem por padrão em algum lugar, viu...
noremap('n', '<Esc>', ':noh<CR>')

-- Rodar linter e testes automatizados de dentro do vim (tem que ter um "runner" setado antes)
-- Dependendo do tipo de arquivo, será feito algo diferente.
-- Linguagens configuradas:
-- - Ruby (rubocop e rspec)
-- - Elixir (credo/formatter e test)
-- Mnemônicos: rubocop all (rua), rubocop file (ruf), rubocop main/master (rum)
--             rspec all (ra), rspec (rs), rspec near (rn),
--             rspec directory (rd), rspec main/master (rm)
--             attach (<leader>a)

-- Basicamente, "ru" = linter (RUbocop) e "r" = testes (Rspec)

-- Setar um runner pro Vim Tmux Runner e mandar alguns sinais úteis, como
-- Control + d e Control + c
-- I don't know why, but one day I woke up and it stopped doing this, even
-- though the last commit on this plugin was 6 months ago.
-- So I created my own function that does some checks.
local function tmuxShowPanesNumbersOnAttatchIfMultiplePanes()
  -- If tmux not running, exits.
  if os.getenv('TMUX') == nil then return end

  -- If command somehow fails, exits.
  -- If there is some tmux in the background, this command returns
  -- something, even if nvim is not inside tmux, so that's why the
  -- env var TMUX check above is necessary.
  local tmux_panes = io.popen('tmux list-panes')
  if tmux_panes == nil then return end

  -- If only one tmux pane, exits.
  local _ = tmux_panes:read()
  local second_read = tmux_panes:read()
  if second_read == nil then
    print('No other tmux panes')
    return
  end

  -- If more than 2 panes (at least two other than neovim itself),
  -- shows panes' numbers on screen.
  local third_read = tmux_panes:read()
  tmux_panes:close()
  if third_read then vim.cmd('silent !tmux display-panes') end

  -- When only exactly two panes, attaches directly.
  -- Using pcall so I can cancel it with <C-c> without
  -- getting a giant error message.
  pcall(vim.cmd.VtrAttachToPane)
end
noremap('n', '<leader>A', vim.cmd.VtrAttachToPane)
noremap('n', '<leader>a', tmuxShowPanesNumbersOnAttatchIfMultiplePanes)
noremap('n', '<A-d>', vim.cmd.VtrSendCtrlD)
noremap('n', '<A-c>', vim.cmd.VtrSendCtrlC)

-- linter all & linter this file
noremap('n', '<leader>rua', ':silent!wa<CR>:lua RunLinter {}<CR>')
noremap('n', '<leader>ruf', ':silent!wa<CR>:lua RunLinter { cur_file = true }<CR>')
-- The "n" stands for "near", makes sense to me to be equal to "ruf", "f" for "file"
noremap('n', '<leader>run', ':silent!wa<CR>:lua RunLinter { cur_file = true }<CR>')

-- test all, test this file, test this file this line & test this directory
noremap('n', '<leader>ra', ':silent!wa<CR>:lua RunAutomatedTest {}<CR>')
noremap('n', '<leader>rs', ':silent!wa<CR>:lua RunAutomatedTest { cur_file = true }<CR>')
noremap('n', '<leader>rn', ':silent!wa<CR>:lua RunAutomatedTest { cur_file = true, cur_line = true }<CR>')
noremap('n', '<leader>rd', ':silent!wa<CR>:lua RunAutomatedTest { cur_dir = true }<CR>')
-- TODO make this actually work/be good. Meanwhile,
-- it is probably best to just send !! via Vtr.
noremap('n', '<leader>rp', ':silent!wa<CR>:lua RunLastTest()<CR>')

-- Pegando os arquivos no diff com a main/master e executando testes/linters
-- Mmenônicos: rspec-main (rm) e rubocop-main (rum)
noremap('n', '<leader>rm', ':silent!wa<CR>:lua FromGit.genericTest()<CR>')
noremap('n', '<leader>rum', ':silent!wa<CR>:lua FromGit.genericLinter()<CR>')

-- Run last command executado no painel "anexado"
-- Na verdade simplesmente executa !!, que só vai funcionar num shell, mesmo
noremap('n', '<leader>rl', ":silent!wa<CR>:call VtrSendCommand('!!')<CR>")

-- Executa o arquivo como um script a depender do seu "filetype"
-- Ver o script para detalhes
noremap('n', '<leader>rr', ':silent!wa<CR>:lua ExecuteFileAsScript()<CR>', { silent = true })
noremap('n', '<leader>R', ':lua AutoExecuteOnSave()<CR>', { silent = true })

-- Tenta compilar o arquivo a depender do seu "filetype"
noremap('n', '<leader>rc', ':silent!wa<CR>:lua CompileFile()<CR>')

--- "Snippets" ---
local snips_path = (vim.fn.stdpath('config'))..'/snippets'
noremap('n', ',html', ':read '..snips_path..'/html5<CR>i<Backspace><C-c>6jf>l')
noremap('n', ',rfce', ":read "..snips_path.."/reactfunctcomp<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>5k")
-- noremap('n', ',vcomp', ":read "..snips_path.."/vuecomp<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>0")
-- noremap('n', ',exm', ":read "..snips_path.."/elixirmodule<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>jS")
noremap('n', ',go', ':read '..snips_path..'/gomain<CR>i<Backspace><C-c>5jS')

-- Buscar por uma sequência de <<<<<<<, ======= ou >>>>>>>
-- Pra usar quando tem conflitos no git
noremap('n', '<leader>/', '/\\(<\\|=\\|>\\)\\{7\\}<CR>')

-- Colocar o shebang #!/bin/sh e dar permissão de execução ao arquivo (o silent = true não ta funcionando?)
noremap('n', ',sh', 'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>', { silent = true })
noremap('n', ',SH', 'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>', { silent = true })
noremap('n', ',Sh', 'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>', { silent = true })
noremap('n', ',sH', 'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>', { silent = true })

-- "Zoom" na split atual e deixar as splits o mais parecidas possível
noremap('n', '<leader>-', ':wincmd _<CR>:wincmd |<CR>')
noremap('n', '<leader>=', ':wincmd =<CR>')

-- Tries to find the test file of current file or vice versa.
-- Works well with elixir and its organized and predictable paths.
noremap('n', '<leader>e', function() TestAndFile.toggle() end, { silent = true })

function RELOAD()
  local config_path = vim.fn.stdpath('config')
  vim.cmd(':so '..config_path..'/init.lua')
  vim.cmd(':luafile '..config_path..'/lua/keymappings.lua')
  vim.cmd(':luafile '..config_path..'/lua/settings.lua')
  print('REALOAD(): Sourcing init.vim, lua/keymappings.lua and lua/settings.lua')
end

noremap('n', '<leader>zl', RELOAD)
