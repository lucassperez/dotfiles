set nocompatible
syntax on
" set synmaxcol=121 " caso a linha seja tão grande que ultrapasse 120 colunas, não tem
"                   " mais marcação de sintaxe. É interessante até para a performance
" " https://vim.fandom.com/wiki/Fix_syntax_highlighting
syntax sync minlines=256

set undodir=~/.config/nvim/undodir " determina diretório pro arquivo pra poder dar undo

""" Plugins """
filetype plugin on
call plug#begin('~/.config/nvim/plugged')
" https://github.com/yegappan/mru tentar esse qualquer dias desses
" https://github.com/neoclide/redismru.vim ou esse

" Joguinho
" Plug 'ThePrimeagen/vim-be-good'
" Plug 'alec-gibson/nvim-tetris'

" Plug 'jghauser/mkdir.nvim'
" Plug 'code-biscuits/nvim-biscuits'

" Funcionalidades de verdade
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
" Plug 'LkeMitchll/vim-kitty-runner'
" Plug 'knubie/vim-kitty-navigator'
" Plug 'vim-test/vim-test'

Plug 'tpope/vim-surround'
" Ragtag OBS1
Plug 'tpope/vim-ragtag'
Plug 'cohama/lexima.vim'
" Plug 'vim-scripts/tComment'
Plug 'tpope/vim-commentary/'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-fugitive'
Plug 'antoinemadec/FixCursorHold.nvim'
let g:cursorhold_updatetime=100
Plug 'kyazdani42/nvim-tree.lua'
Plug 'airblade/vim-gitgutter'
Plug 'thoughtbot/vim-rspec'
" Plug 'kyazdani42/nvim-web-devicons'
" Plug 'psliwka/vim-smoothie'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'andyl/vim-textobj-elixir'
Plug 'mhinz/vim-startify'
" Plug 'windwp/nvim-ts-autotag'
Plug 'alvan/vim-closetag'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'hrsh7th/cmp-buffer'

" Coisas LSP e TreeSitter
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'glepnir/lspsaga.nvim'
" Plug 'nvim-treesitter/nvim-treesitter', {'branch' : '0.5-compat'}
" Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch' : '0.5-compat'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'hrsh7th/nvim-compe'

" Marcadores de sintaxe
" Plug 'tpope/vim-rails'
" Plug 'tpope/vim-bundler'
" Plug 'styled-components/vim-styled-components'
Plug 'elixir-editors/vim-elixir'
" Plug 'MaxMEllon/vim-jsx-pretty'
" Plug 'leafOfTree/vim-vue-plugin'
" Plug 'pangloss/vim-javascript' " esse é o que quebra o rainbow
" Plug 'elzr/vim-json'
" Plug 'vim-ruby/vim-ruby'

" Ajudinha visual
Plug 'ap/vim-buftabline'
" Plug 'Yggdroot/indentLine'
" Esse rainbow por algum motivo está quebrando a
" interpolação de strings em arquivos elixir ):
" Plug 'p00f/nvim-ts-rainbow'
Plug 'hoob3rt/lualine.nvim'

" Coisas que tem a ver com cores e visual
Plug 'rktjmp/lush.nvim'
Plug 'tjdevries/colorbuddy.nvim'
" Plug 'xiyaowong/nvim-transparent'
Plug 'norcalli/nvim-colorizer.lua'

" Esquema de cores
" Plug 'https://github.com/morhetz/gruvbox/'
" Plug 'jdsimcoe/abstract.vim'
" Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'
" Plug 'folke/tokyonight.nvim'
" Plug 'dikiaap/minimalist'
" Plug 'tomasr/molokai'
" Plug 'fmoralesc/molokayo'
" Plug 'marcopaganini/termschool-vim-theme'
" Plug 'christianchiarulli/nvcode-color-schemes.vim'
" Plug 'mhartington/oceanic-next'
" Plug 'arzg/vim-colors-xcode'
" Plug 'RRethy/nvim-base16'
" Plug 'Th3Whit3Wolf/onebuddy'
" Plug 'mhinz/vim-janah'
call plug#end()

lua <<EOF
require('init')
EOF

" destacar a linha atual
" set cursorline
" colorscheme
" let ayucolor="mirage"
" colorscheme ayu
" source $HOME/.config/nvim/color/general.vim
source $HOME/.config/nvim/color/perez-cs.vim
" lua require'colorizer'.setup()
highlight CursorLine cterm=NONE ctermbg=0 gui=NONE guibg=#434d48

" OBS1
" Adicionado arquivos vue na raiz do vim-ragtag. Talvez devesse abrir um PR?

" Customizando FZF
let g:fzf_layout = { 'down': '30%' }
let g:fzf_preview_window = ['right:65%:hidden', 'ctrl-/']

" " Customizando o lexima (auto close de coisas) do meu jeito
" source $HOME/.config/nvim/lexima.custom.vim
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" Eu odeio esconder as aspas
let g:vim_json_syntax_conceal=0

" Opções pro plugin Yggdroot/indentLine conseguir mostrar os leading whitespaces
" let g:indentLine_fileTypeExclude=['json', 'markdown', 'dockerfile']
" let g:indentLine_leadingSpaceEnabled = 1
" let g:indentLine_leadingSpaceChar = '·'
" let g:indentLine_char_list=['·']
" let g:indentLine_concealcursor='·'

" let g:indent_blankline_char='│' " '¦', '┆', '┊'
" let g:indent_blankline_space_char='·'
" let g:indent_blankline_filetype_exclude = ['json', 'markdown']

" Opções pro buftabs
let g:buftabline_indicators=1 " mostrar se tem alteração no arquivo ou não

""" Configurações gerais """
let &titlestring='nvim'
set encoding=utf8 " vai, Brasil!
set list listchars=tab:<->,trail:·,nbsp:·,extends:»,precedes:« " mostrar whitespaces, kinda off
" Mudando a status line pra ficar algo tipo assim:
" [relative/path/to/file[+]                l:1/200,c:32]
" set statusline=%f%m%r%h%w%=\ l:%l\/%L,c:%v
" Alterei pro lualine por enquanto
set complete-=i " https://medium.com/usevim/set-complete-e76b9f196f0f
" set lazyredraw

" Destacar colunas depois do 80 e 120
let &colorcolumn='81,121'
highlight ColorColumn ctermbg=239 guibg=#4e4e4e
set textwidth=0 " porém, não quero que ele automaticamente coloque uma linha nova ao chegar aí

" set nobackup nowritebackup " Oh, meu Deus!
" set noswapfile " e essa porcaria aqui

" set mouse=a

" set wildmenu " aquele menuzinho de autocomplete no command mode
" set wildmode=list:full " opções do wildmenu
" set wildmode=longest,list " opções do wildmenu
" set wildignore=**/node_modules/**
" set wildignorecase

" Hífen não key word faz com que super-mercado sejam duas (ou três) "palavras",
" ou seja, com o cursor em "s", apertar w não vai colocá-lo em "o"
set iskeyword-=- "https://vi.stackexchange.com/questions/18197/how-to-get-w-word-and-b-back-to-treat-hyphens-and-underscores-like-spaces

" Novas splits não derretem meu cérebro quando criadas
" set splitbelow splitright

""" Remaps """
" O cifrão é muito longe q-q e o cedilha acho que está (estava) livre?
" map ç $
"
" " Copiar para o clipboard do sistema o caminho do arquivo
" nnoremap <leader>f :let @+ = expand("%")<CR>
"
" " Abrir o init.vim num painel vertical para editar e dar source nele
" " Pra lembrar, ev seria "Edit Vim" e sv seria "Source Vim"
" nnoremap <leader>ev :vnew ~/.config/nvim/init.vim<CR>
" nnoremap <leader>sv :so ~/.config/nvim/init.vim<CR>

" " Não entrar no insert mode após usar leader + o/O
" nnoremap <leader>o o<C-c>
" nnoremap <leader>O O<C-c>

" nnoremap <leader>C 0f=lC<Space>

" " Abrir links no firefox (quebra quando tem # :C)
" nnoremap gx :!firefox <C-r><C-a><CR>

" " Buffer anterior
" nnoremap <leader>q :bprevious<CR>
" " Próximo buffer
" nnoremap <leader>w :bnext<CR>
" " Fecha o buffer atual
" nnoremap <leader>d :bd<CR>

" " Mudar de painéis segurando Control
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Coisas do fzf
" nnoremap <C-p> :GFiles<CR>
" nnoremap <C-f> :Ag<CR>
" nnoremap <leader>p :Files<CR>
" nnoremap <leader>h :History<CR>

" Copiar para o clipboard
" vnoremap  <leader>y  "+y
" nnoremap  <leader>y  "+y
" nnoremap  <leader>Y  "+yg_

" " Colar do clipboard
" Conflito com as minhas configs do fzf
" nnoremap <leader>p "+p
" nnoremap <leader>P "+P
" vnoremap <leader>p "+p
" vnoremap <leader>P "+P

" " Mudar a indentaçãõ continuamente
" " https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc
" " Modo visual
" vnoremap < <gv
" vnoremap > >gv
" vnoremap <Tab> >gv
" vnoremap <S-Tab> <gv
" " Modo normal
" nnoremap > >>
" nnoremap < <<

" Como <Tab> e <C-i> são iguais, tive que desabilitar esse remap pra não perder
" a funcionalidade do <C-I>... Srsly?
" Ctrl+I = Tab
" Ctrl+J = Newline
" Ctrl+M = Enter
" Ctrl+[ = Escape
" https://github.com/preservim/nerdtree/issues/761
" https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
" nnoremap <Tab> >>
" nnoremap <S-Tab> <<

" Usar shift+tab como <C-o>, já que tab = <C-i>
nnoremap <S-Tab> <C-o>
" <C-i> e <C-o> pulam pelos lugares que o cursor esteve
" bizarramente, <C-i> e <Tab> disparam a mesma sequência (put* que me pariu, hein)
" Logo, <S-Tab> poderia ser <C-o> pra fazer parzinho com <Tab>, que é <C-i>

" Mover blocos de texto
""" Visual mode com J e K e <C-j> e <C-k>
" vnoremap J :m '>+1<CR>gv=gv
" vnoremap K :m '<-2<CR>gv=gv
" vnoremap <C-j> :m '>+1<CR>gv=gv
" vnoremap <C-k> :m '<-2<CR>gv=gv
""" Insert e normal modes com <C-j> e <C-k>
" inoremap <C-j> <C-c>:m .+1<CR>==i
" inoremap <C-k> <C-c>:m .-2<CR>==i

" " Mudar o tamanho dos painéis
" nnoremap <C-Down> :resize -3<CR>
" nnoremap <C-Up> :resize +3<CR>
" nnoremap <C-Left> :vertical resize -5<CR>
" nnoremap <C-Right> :vertical resize +5<CR>

" Control + Del no insert mode
" inoremap <C-Del> <C-o>de
" Note que pra apagar pra trás, Control + w funciona

" " Colocar 3 (ou 6) crases, porque ninguém merece essa porcaria
" nnoremap <leader>ç i```<CR>```<CR><C-c>2kA

" É brincadeira que :noh<CR> não vem por padrão em algum lugar, viu...
" nnoremap <Esc> :noh<CR>

" Setar um runner pro Vim Tmux Runner
" nnoremap <leader>a :VtrAttachToPane<CR>
" " Rodar rubocop e rspec do vim (tem que ter um "runner" setado antes)
" " rubocop file, rubocop, rspec all, rspec, rspec near, rspec directory, attach
" nnoremap <leader>rfu :call VtrSendCommand('bundle exec rubocop '.expand('%'))<CR>
" nnoremap <leader>ru :call VtrSendCommand('bundle exec rubocop')<CR>
" nnoremap <leader>ra :call VtrSendCommand('bundle exec rspec')<CR>
" nnoremap <leader>rs :call VtrSendCommand('bundle exec rspec '.expand('%'))<CR>
" nnoremap <leader>rn :call VtrSendCommand('bundle exec rspec '.expand('%').':'.line('.'))<CR>
" nnoremap <leader>rd :call VtrSendCommand('bundle exec rspec '.expand('%:h'))<CR>
" " Não sabia que existia o vim-rspec, mas como já fiz a maoria na mão...
" nnoremap <leader>rl :call RunLastSpec()<CR>

let g:KittyUseMaps=1

""" Snippets """
" nnoremap ,html :-1read $HOME/.config/nvim/snippets/html5<CR>5jf>l
nnoremap ,rfce :-1read $HOME/.config/nvim/snippets/reactfunctcomp<CR>:%s/$1/\=expand('%:t:r')/g<CR>5k
" nnoremap ,clg :-1read $HOME/.config/nvim/snippets/console.log<CR>==f)i
" iabbrev clg, console.log
" ainda ta ruim esse do console.log ):
" nnoremap ,rspec :-1read $HOME/.config/nvim/snippets/rubyspec<CR>2j6l
" nnoremap ,stl :-1read $HOME/.config/nvim/snippets/styledcomps<CR>j
nnoremap ,vcomp :-1read $HOME/.config/nvim/snippets/vuecomp<CR>:%s/$1/\=expand('%:t:r')/g<CR>0
" nnoremap ,exm :-1read $HOME/.config/nvim/snippets/elixirmodule<CR>:%s/$1/\=expand('%:t:r')/g<CR>jS


" Eu odeio demais formatoptions "t", "c", "r" e "o" ):<
" t = auto wrap
" c = auto wrap comentários
" r = nova linha também é comentário se apertar enter dentro de um comentário
" o = nova linha também é comentário se apertar o dentro de um comentário
" q = pode formatar comentários com o comando "gq" (??) Nem sei o que é isso
" l = não auto formata quando acaba a linha no insert mode (EXATAMENTE O QUE EU QUERO)
autocmd Filetype * setlocal formatoptions=ql
setlocal formatoptions=ql

" Colocar uma corzinha nos pares de parentesis/colchetes/chaves quando o cursor
" estiver sobre eles
hi MatchParen guifg=#87ff00 gui=BOLD,UNDERLINE ctermfg=yellow cterm=BOLD,UNDERLINE

" function! PreviewMarkdown()
"   let l:path=expand('%:p')
"   silent execute "!echo ".l:path." > ~/.last-md-preview.log"
"   :execute "bel vert terminal"
" endfunction

" NvimTree
source $HOME/.config/nvim/tree-config.vim

" Alterar a cor da numeração das linhas com alguma alteraao (git gutter)
set signcolumn=no
let g:gitgutter_signs=0
let g:gitgutter_highlight_linenrs=1

hi GitGutterAddLineNr          guifg=#00af00 gui=BOLD           ctermfg=34  cterm=BOLD
hi GitGutterChangeLineNr       guifg=#c39f00 gui=ITALIC,BOLD    ctermfg=3   cterm=ITALIC,BOLD
hi GitGutterDeleteLineNr       guifg=#ec2929 gui=UNDERLINE,BOLD ctermfg=red cterm=UNDERLINE,BOLD
hi GitGutterChangeDeleteLineNr guifg=#d75f00 gui=UNDERCURL,BOLD ctermfg=166 cterm=UNDERCURL,BOLD

runtime macros/matchit.vim
let ruby_foldable_groups='if def class module'

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

let g:closetag_filetypes = 'html,eelixir,javascript,javascriptreact'
" let g:surround_{char2nr('=')} = "<%= \r %>"
" let g:surround_{char2nr('-')} = "<% \r %>"
