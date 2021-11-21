local o = vim.o   -- global options
local bo = vim.bo -- buffer options
local wo = vim.wo -- window options

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
o.backspace = "2" -- conseguir apagar identações, também
o.lazyredraw = true
-- o.undodir = ???
o.undofile = true -- arquivo para poder dar undo no diretório acima
o.backup = false
o.writebackup = false
o.mouse = 'a' -- habilita o mouse (a significa all). Sacrilégio!
o.wildmenu = true
o.wildmode = 'longest,list'
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
