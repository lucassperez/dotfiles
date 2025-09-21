-- global
vim.o.confirm = true -- pede confirmação ao tentar fechar um buffer com alterações

local my_shiftwidth = 2
vim.o.tabstop = my_shiftwidth -- tamanho do tab
vim.o.shiftwidth = my_shiftwidth -- números de espaços pra usar para cada indentação
vim.o.expandtab = true -- tab com espaços

vim.o.ignorecase = true -- busca case insensitive
vim.o.smartcase = true -- busca case sensitive SSE tiver pelo menos uma letra maiúscula
vim.o.scrolloff = 1 -- sempre mostra pelo menos uma linha abaixo e acima do cursor
vim.o.sidescrolloff = 3 -- sempre mostra pelo menos três colunas à direita e à esquerda do cursor
vim.o.lazyredraw = true -- espera o macro acabar pra redesenhar a tela ao invés de ir redesenhando enquanto executa o macro
vim.o.mouse = 'a' -- habilita o mouse (a significa all). Sacrilégio!
vim.o.showmode = false -- não mostra o modo na linha de comando. Posso fazer isso com a statusline se eu quiser

vim.o.wildignore = '**/node_modules/**' -- porque né, ninguém merece esse treco gigante
vim.o.wildignorecase = true -- auto complete case insensitive
-- https://www.reddit.com/r/neovim/comments/10rsl92/how_to_complete_longest_common_text_in_command/?sort=new
vim.o.wildmode = 'longest:full,full' -- completa primeiro só até o texto comum mais longo

vim.o.virtualedit = 'block'

-- Novas splits não derretem meu cérebro quando criadas
vim.o.splitbelow = true
vim.o.splitright = true

-- buffer
vim.bo.swapfile = false

-- window
vim.wo.colorcolumn = '81,121'
vim.wo.cursorline = true
vim.wo.number = true -- número das linhas
vim.wo.relativenumber = true -- números relativos (tipo distâncias) ao cursor
vim.wo.numberwidth = 3 -- tamanho mínimo da coluna pros números à esquerda
vim.wo.wrap = false -- sem wrap quando o texto chega no final da tela
-- vim.o.breakindent -- isso é útil se um dia eu quiser usar wrap
vim.wo.signcolumn = 'no'

-- List mode tem que estar ligado para conseguir usar o listchars
vim.wo.list = true
vim.opt.listchars = {
  -- tab = '<->',
  -- tab = '⮡ ',
  -- tab = '⤷ ',
  tab = '│ ',
  trail = '·',
  nbsp = '%',
  extends = '»',
  precedes = '«',
  leadmultispace = '┊' .. string.format('%-' .. (vim.o.shiftwidth - 1) .. 's', ''),
}
vim.opt.textwidth = 0
-- Eu odeio demais formatoptions "t", "c", "r" e "o" ):<
-- t = auto wrap
-- c = auto wrap comentários
-- r = nova linha também é comentário se apertar enter dentro de um comentário
-- o = nova linha também é comentário se apertar o dentro de um comentário
-- q = pode formatar comentários com o comando "gq" (??) Nem sei o que é isso
-- l = não auto formata quando acaba a linha no insert mode (exatamente o que eu quero)
-- j = junta comentários de maneira inteligente apertando J
-- :help fo-table para mais informações
vim.api.nvim_create_autocmd('Filetype', {
  pattern = '*',
  callback = function()
    vim.bo.formatoptions = 'jql'
    -- vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
  once = false,
})
-- vim.cmd('autocmd Filetype * setlocal formatoptions=jql')

-- https://www.reddit.com/r/neovim/comments/ppv7vr/comment/hd7v2ol/?utm_source=share&utm_medium=web2x&context=3
vim.opt.undodir = { vim.fn.stdpath('config') .. '/undodir' }
vim.o.undofile = true -- arquivo para poder dar undo no diretório acima
vim.opt.complete:remove('i') -- https://medium.com/usevim/set-complete-e76b9f196f0f

-- :help vim.highlight.on_yank()
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 80, higroup = 'HighlightOnYank' })
  end,
  group = highlight_group,
  pattern = '*',
  desc = 'Highlight on yank',
})

-- Folding commands
-- :help zm, zM, zo, zR, ]z, zj
-- "You can fold natively on nvim. Just zc to close and zo to open in normal mode."
-- Folding options
vim.opt.fillchars = { fold = ' ' }
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.g.markdown_folding = 1 -- enable markdown folding
