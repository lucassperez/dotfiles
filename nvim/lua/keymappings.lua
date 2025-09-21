-- Apparently, vim.keymap.set only works with "remap", and not "noremap".
-- "Noremap" only works with vim.api.nvim_set_keymap.
-- opts.noremap = true
-- Also, vim.keymap.set defaults "remap" to false anyways (noremap true).
-- But vim.api.nvim_set_keymap defaults noremap to false. Also, it does
-- not accept "remap" key in opts.

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<leader>M', ':Inspect<CR>', {
  desc = 'Mostra informações, como o grupo de destaque (highlight), da coisa/palavra embaixo do cursor usando a funcionalidade padrão Inspect',
})

vim.keymap.set('n', '<leader>m', ':FloatingInspect<CR>', {
  desc = 'Mostra o grupo de destaque (highlight) da coisa/palavra embaixo do cursor numa janela flutuante usando minha função customizada FloatingInspect',
})

-- Search only in visual area when in visual mode.
vim.keymap.set('x', '/', '<Esc>/\\%V') --search within visual selection - this is magic

-- https://vim.fandom.com/wiki/Format_pasted_text_automatically
-- Some options:
--   p to p==
--   p to ]p
--   p to p=`]
--   p to p=`]^
if vim.bo.filetype ~= '' then
  vim.keymap.set({ 'n', 'v' }, 'p', 'p=`]^')
  vim.keymap.set({ 'n', 'v' }, 'P', 'P=`]^')
end

-- Go to command mode without using shift
vim.keymap.set({ 'n', 'v' }, ';', ':')

-- Map some commands do not copy empty line to register.
-- Also does not copy line made of only whitespaces.
-- Do I really want this? :thinking:

local function mapWhitespaceLine(command)
  -- TODO find a way to make this work in visual mode.
  -- How to get selection area?
  vim.keymap.set('n', command, function()
    if vim.api.nvim_get_current_line():match('^%s*$') then return '"_' .. command end
    return command
  end, {
    expr = true,
    desc = 'Executes `' .. command .. '` without copying whitespaces only to register (hopefully)',
  })
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

    if char_under_cursor:match('%s') then return '"_' .. command end
    return command
  end, {
    expr = true,
    desc = 'Executes `' .. command .. '` without copying whitespaces only to register (hopefully)',
  })
end

mapWhitespaceCharacter('s')
-- I actually don't want it for specifically x
-- mapWhitespaceCharacter('x')

-- Cansei de fazer isso aqui sem querer
-- Ainda é possível acessar o histórico
-- usando <C-f> durante o modo de comando (aperta : e depois <C-f>)
vim.keymap.set('n', 'q:', '<Nop>')

-- Normally C-c already does this, but after installing LSP, the text box
-- containing completions would sometimes not properly disappear when I C-c out
-- of insert mode, which did not happen with Esc.
-- This probably happens because C-c don't fire the InsertLeave event. Here we
--  map it to <Esc> for it to start firing this event.
vim.keymap.set('i', '<C-c>', '<Esc>')

-- Novos paineis (horizontal e vertical) e fechar o atual
vim.keymap.set('n', '<leader>s', ':sp<CR>', { desc = 'Abre uma janela horizontal' })
vim.keymap.set('n', '<leader>v', ':vs<CR>', { desc = 'Abre uma janela vertical' })
vim.keymap.set('n', '<leader>c', '<C-w>c', { desc = 'Fecha janela atual' })

-- Salvar e fechar tudo, eita.
-- Writes and quits from everything, omg!
-- Files without a name are not saved.
vim.keymap.set('n', '<C-q>', function()
  for _, buf in pairs(vim.fn.getbufinfo()) do
    -- If it has a name, is listed and has changes
    if buf.name ~= '' and buf.listed ~= 0 and buf.changed ~= 0 then
      vim.cmd('buffer ' .. buf.bufnr)
      vim.cmd('w')
    end
  end
  vim.cmd('qa!')
end, {
  desc = 'Salva e fecha todos os buffers, saindo do vim. Caso algum buffer seja de um arquivo ainda não existente no disco, ele será perdido',
})

-- In visual mode, L does not get the "new line" at the end, and H does
-- not go to the first column, but instead to the first character in the line.
-- I'm not sure I know what I'm doing with noremap = false
vim.keymap.set({ 'n', 'o' }, 'L', '$', { desc = 'Vai para o final da linha', noremap = false })
vim.keymap.set('v', 'L', '$h', { desc = 'Vai para o final da linha', noremap = false })
vim.keymap.set({ 'n', 'v', 'o' }, 'H', '^', { desc = 'Vai para o começo da linha', noremap = false })

-- Abrir o último arquivo editado
-- C-6 already does this, see :h CTRL-6 and :h alternate-file
-- vim.keymap.set('n', '<leader><Space>', ':e#<CR>', { desc = 'Abre o último arquivo (:h alternate-file)', })
vim.keymap.set('n', '<leader><Space>', '<C-6>', { desc = 'Abre o último arquivo (:h alternate-file)' })

-- Copiar para o clipboard do sistema o caminho do arquivo
vim.keymap.set(
  'n',
  '<leader>f',
  ':let @+ = expand("%:p")<CR>',
  { desc = 'Copia o caminho do arquivo para o clipboard do sistema' }
)

-- Não entrar no insert mode após usar leader + o/O
vim.keymap.set(
  'n',
  '<leader>o',
  'o<C-c>',
  { desc = 'Insere linha abaixo, como o, mas saindo do modo de inserção no final' }
)
vim.keymap.set(
  'n',
  '<leader>O',
  'O<C-c>',
  { desc = 'Insere linha acim, como O, mas saindo do modo de inserção no final' }
)

-- Abrir links no firefox (quebra quando tem # :C)
-- O plugin nvim-various-textobjects ta fazendo isso já e de forma
-- mais inteligente, inlcusive tratando quando tem # na url, e
-- usando xdg-open pra abrir o site com o aplicativo padrão.
-- vim.keymap.set('n', 'gx', ':!firefox <C-r><C-a><CR>', desc = { desc = 'Tenta abrir a url embaixo do cursor com o Firefox', })

-- Ir para o buffer anterior/próximo e fechar o atual
-- O plugin barbar.vim estaria sobrescrevendo esses mappings de qualquer forma
vim.keymap.set('n', '<leader>q', ':bprevious<CR>', { desc = 'Mostra o buffer anterior' })
vim.keymap.set('n', '<leader>w', ':bnext<CR>', { desc = 'Mostra o próximo buffer' })
vim.keymap.set('n', '<leader>d', ':bdelete<CR>', { desc = 'Fecha o buffer atual' })
vim.keymap.set('n', '<A-q>', ':bprevious<CR>', { desc = 'Mostra o buffer anterior' })
vim.keymap.set('n', '<A-w>', ':bnext<CR>', { desc = 'Mostra o próximo buffer' })

-- Tab management maps using similar logic to buffer mappings above
-- Vim actually has some built-ins!
-- gt go to next tab (like tabnext)
-- gT go to previous tab (like tabprevious)
-- {count}gt go to tab number {count} (nice!)
-- g<Tab> go to last accessed tab (nice!)
vim.keymap.set('n', '<leader>tn', function()
  return ('$:tabnew %s<CR>'):format(vim.fn.expand('%'))
end, { expr = true, desc = 'Cria uma nova aba mostrando o arquivo atual, caso ele exista' })
vim.keymap.set('n', '<A-t>', function()
  return ('$:tabnew %s<CR>'):format(vim.fn.expand('%'))
end, { expr = true, desc = 'Cria uma nova aba mostrando o arquivo atual, caso ele exista' })
vim.keymap.set('n', '<leader>td', ':tabclose<CR>', { desc = 'Fecha a aba atual' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Fecha a aba atual' })

-- Mudar de painéis segurando Control
-- O plugin tmux.nvim está fazendo isso
-- vim.keymap.set('n', '<C-h>', '<C-w>h')
-- vim.keymap.set('n', '<C-j>', '<C-w>j')
-- vim.keymap.set('n', '<C-k>', '<C-w>k')
-- vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Copiar para o clipboard do sistema
-- Yank
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copia para o clipboard do sistema' })
vim.keymap.set('n', '<leader>Y', '"+yg_', { desc = 'Copia até o fim da linha para o clipboard do sistema' })
-- Delete
vim.keymap.set('n', '<leader>D', '"+dg_', { desc = 'Recorta até o fim da linha para o clipboard do sistema' })

-- Mudar a indentação continuamente
-- https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc
---- I don't know about this, but oh well
-- Modo visual
vim.keymap.set('v', '<', '<gv', { desc = 'Indenta e seleciona a mesma área anterior' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indenta e seleciona a mesma área anterior' })
-- Modo normal
vim.keymap.set('n', '>', '>>', { desc = 'Indenta direto, sem receber um objeto' })
vim.keymap.set('n', '<', '<<', { desc = 'Indenta direto, sem receber um objeto' })

-- Mover blocos de texto
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Move blocos de texto para baixo' })
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Move blocos de texto para cima' })
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { desc = 'Move blocos de texto para baixo' })
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { desc = 'Move blocos de texto para cima' })

-- Mudar o tamanho dos painéis
vim.keymap.set('n', '<C-Down>', ':resize -3<CR>', { desc = 'Diminui (é meio confuso) o tamanho de uma janela por 3' })
vim.keymap.set('n', '<C-Up>', ':resize +3<CR>', { desc = 'Aumenta (é meio confuso) o tamanho de uma janela por 3' })
vim.keymap.set(
  'n',
  '<C-Left>',
  ':vertical resize -5<CR>',
  { desc = 'Diminui (é meio confuso) o tamanho de uma janela por 5' }
)
vim.keymap.set(
  'n',
  '<C-Right>',
  ':vertical resize +5<CR>',
  { desc = 'Aumenta (é meio confuso) o tamanho de uma janela por 5' }
)

-- Control + Del no insert mode
-- Note que pra apagar pra trás, Control + w funciona
vim.keymap.set('i', '<C-Del>', '<C-o>de', { desc = 'Deleta a palavra seguinte' })

-- Se receber true como argumento, essa função escreve na linha anterior. A
-- ideia é como os comandos `o` e `O`, só que pra um debugger (binding.pry no
-- ruby, IEx.pry no elixir). Se segurar shift em algum momento, manda pra linha
-- de cima (recebe true como argumento), do contrário, manda pra linha de baixo.
vim.keymap.set('n', ',bp', function()
  WriteDebuggerBreakpoint()
end, { silent = true, desc = 'Tenta escrever a entrada para o debugger na linha de baixo' })
vim.keymap.set('n', ',BP', function()
  WriteDebuggerBreakpoint(true)
end, { silent = true, desc = 'Tenta escrever a entrada para o debugger na linha de cima' })
vim.keymap.set('n', ',Bp', function()
  WriteDebuggerBreakpoint(true)
end, { silent = true, desc = 'Tenta escrever a entrada para o debugger na linha de cima' })
vim.keymap.set('n', ',bP', function()
  WriteDebuggerBreakpoint(true)
end, { silent = true, desc = 'Tenta escrever a entrada para o debugger na linha de cima' })

-- É brincadeira que :noh<CR> não vem por padrão em algum lugar, viu...
vim.keymap.set('n', '<Esc>', ':noh<CR>', { desc = 'Remove os destaques feitos por busca' })

--- "Snippets" ---
local snips_path = vim.fn.stdpath('config') .. '/snippets'
vim.keymap.set('n', ',html', ':read ' .. snips_path .. '/html5<CR>i<Backspace><C-c>6jf>l')
vim.keymap.set(
  'n',
  ',rfce',
  ':read ' .. snips_path .. "/reactfunctcomp<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>5k"
)
-- vim.keymap.set('n', ',vue', ':read '..snips_path.."/vuecomp<CR>i<Backspace><C-c>:%s/$1/=expand('%:t:r')/g<CR>0")
vim.keymap.set('n', ',go', ':read ' .. snips_path .. '/gomain<CR>i<Backspace><C-c>5jS')

-- Buscar por uma sequência de <<<<<<<, ======= ou >>>>>>>
-- Pra usar quando tem conflitos no git
vim.keymap.set('n', '<leader>/', '/\\(<\\|=\\|>\\)\\{7\\}<CR>', { desc = 'Busca por marcadores de conflitos do git' })

-- Colocar o shebang #!/bin/sh e dar permissão de execução ao arquivo (o silent = true não ta funcionando?)
vim.keymap.set(
  'n',
  ',sh',
  'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>',
  { silent = true, desc = 'Colocar o shebang #!/bin/sh e dar permissão de execução ao arquivo' }
)
vim.keymap.set(
  'n',
  ',SH',
  'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>',
  { silent = true, desc = 'Colocar o shebang #!/bin/sh e dar permissão de execução ao arquivo' }
)
vim.keymap.set(
  'n',
  ',Sh',
  'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>',
  { silent = true, desc = 'Colocar o shebang #!/bin/sh e dar permissão de execução ao arquivo' }
)
vim.keymap.set(
  'n',
  ',sH',
  'ggI#!/bin/sh<CR><CR><C-c>:w<CR>:!chmod +x %<CR>',
  { silent = true, desc = 'Colocar o shebang #!/bin/sh e dar permissão de execução ao arquivo' }
)

-- "Zoom" na split atual e deixar as splits o mais parecidas possível
vim.keymap.set('n', '<leader>-', ':wincmd _<CR>:wincmd |<CR>', { desc = 'Deixa uma janela com "Zoom"' })
vim.keymap.set('n', '<leader>=', ':wincmd =<CR>', { desc = 'Deixa todas as janelas com o mesmo tamanho' })

-- Tries to find the test file of current file or vice versa.
-- Works well with elixir and its organized and predictable paths.
vim.keymap.set('n', '<leader>e', function()
  TestAndFile.toggle()
end, { silent = true, desc = 'Tenta alternar entre um arquivo e o seu teste' })

function RELOAD()
  local config_path = vim.fn.stdpath('config')
  vim.cmd(':so ' .. config_path .. '/init.lua')
  vim.cmd(':luafile ' .. config_path .. '/lua/keymappings.lua')
  vim.cmd(':luafile ' .. config_path .. '/lua/settings.lua')
  print('REALOAD(): Sourcing init.vim, lua/keymappings.lua and lua/settings.lua')
end

vim.keymap.set('n', '<leader>zl', RELOAD, { desc = 'Recarrega as configs, keymappings e tudo mais do nvim' })
