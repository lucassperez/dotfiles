local o = vim.o   -- global options
local bo = vim.bo -- buffer options
local wo = vim.wo -- window options
-- vim.opt if for things you would `set` in vimscript,
-- vim.g is for things you'd `let`
local opt = vim.opt

-- global
o.hidden  = true -- podemos esconder buffers com alterações
o.confirm = true -- mas se tentar fechar um buffer com alterações, ele primeiro pergunta se quer salvar
o.tabstop = 2 -- tamanho do tab
o.shiftwidth = 2 -- empurrar as coisas por 2 espaços, somente
o.expandtab = true -- tab com espaços
o.title = true -- altera o título do terminal pro arquivo sendo editado
o.titleold = 'Terminal' -- quando fechar o vim, escrever Terminal no título do terminal
o.belloff = 'all' -- sem bips!
o.ignorecase = true -- busca case insensitive
o.smartcase = true -- busca case sensitive SSE tiver pelo menos uma letra maiúscula
o.incsearch = true -- ir gerando resultados enquanto escreve a busca
o.inccommand = 'nosplit' -- ir mostrando também no comando de substituir (ex :%s...)
o.laststatus = 2 -- sempre mostrar a status bar
o.scrolloff = 1 -- sempre mostra pelo menos uma linha abaixo e acima do cursor
o.sidescrolloff = 3 -- sempre mostra pelo menos três colunas à direita e à esquerda do cursor
-- nostop or start?
o.backspace = "indent,eol,start" -- conseguir apagar identações, também
o.lazyredraw = true
o.backup = false
o.writebackup = false
o.mouse = 'a' -- habilita o mouse (a significa all). Sacrilégio!

o.wildmenu = true
-- show everything scattered, multiple per line
-- o.wildmode = 'longest,list'
-- show on a pop up like list, one per line
o.wildmode = 'longest:full'
o.wildignore = '**/node_modules/**' -- porque né, ninguém merece esse treco gigante
o.wildignorecase = true -- auto complete case insensitive

-- Novas splits não derretem meu cérebro quando criadas
o.splitbelow = true
o.splitright = true

-- buffer
bo.smartindent = true -- vai tentar o seu melhor para indentar
bo.autoindent = true  -- as coisas automaticamente
bo.swapfile = false

-- window
wo.cursorline = true
wo.number = true -- número das linhas
wo.relativenumber = true -- números relativos (tipo distâncias) ao cursor
wo.numberwidth = 3 -- tamanho mínimo da coluna pros números à esquerda
wo.wrap = false -- sem wrap quando o texto chega no final da tela

opt.encoding = 'utf8'
-- List mode tem que estar ligado para conseguir usar o listchars
wo.list = true
opt.listchars = {
  -- tab = '<->',
  -- tab = '⮡ ',
  tab = '⤷ ',
  trail = '·',
  nbsp = '·',
  extends = '»',
  precedes = '«',
}
opt.textwidth = 0
-- Eu odeio demais formatoptions "t", "c", "r" e "o" ):<
-- t = auto wrap
-- c = auto wrap comentários
-- r = nova linha também é comentário se apertar enter dentro de um comentário
-- o = nova linha também é comentário se apertar o dentro de um comentário
-- q = pode formatar comentários com o comando "gq" (??) Nem sei o que é isso
-- l = não auto formata quando acaba a linha no insert mode (exatamente o que eu quero)
-- j = junta comentários de maneira inteligente apertando J
-- :h fo-table para mais informações
vim.cmd [[
  autocmd Filetype * setlocal formatoptions=jql
]]
-- o.formatoptions = 'jql'
-- https://www.reddit.com/r/neovim/comments/ppv7vr/comment/hd7v2ol/?utm_source=share&utm_medium=web2x&context=3
vim.opt.undodir = vim.fn.stdpath('config')..'/undodir'
o.undofile = true -- arquivo para poder dar undo no diretório acima
opt.complete:remove('i') -- https://medium.com/usevim/set-complete-e76b9f196f0f

-- AwsomeWM, Vim and Tmux navigator thing
-- vim.g.tmux_navigator_insert_mode = 1
