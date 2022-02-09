-- https://github.com/yegappan/mru tentar esse qualquer dias desses
-- https://github.com/neoclide/redismru.vim ou esse
return require('packer').startup(function()
  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Funcionalidades de verdade
  -- use {
  --   'junegunn/fzf',
  --   run = function () vim.fn['fzf#install']() end
  -- }
  -- use 'junegunn/fzf.vim'
  use 'cohama/lexima.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'christoomey/vim-tmux-runner'
  -- use 'intrntbrn/awesomewm-vim-tmux-navigator'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'tpope/vim-ragtag'
  use 'numToStr/Comment.nvim'
  use 'mattn/emmet-vim'
  use 'tpope/vim-fugitive'
  use 'antoinemadec/FixCursorHold.nvim'
  vim.g.cursorhold_updatetime = 100
  use 'kyazdani42/nvim-tree.lua'
  use 'airblade/vim-gitgutter'
  use 'kana/vim-textobj-user'
  use 'nelstrom/vim-textobj-rubyblock'
  use 'andyl/vim-textobj-elixir'
  use 'mhinz/vim-startify'
  -- use 'windwp/nvim-ts-autotag'
  use 'alvan/vim-closetag'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  -- use 'abecodes/tabout.nvim'
  use 'nvim-lua/plenary.nvim'

  -- Coisas LSP e TreeSitter
  use 'neovim/nvim-lspconfig'
  -- use 'jose-elias-alvarez/null-ls.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'
  use 'hrsh7th/nvim-compe'

  -- Marcadores de sintaxe
  use 'elixir-editors/vim-elixir'

  -- Ajudinha visual
  use 'hoob3rt/lualine.nvim'
  use 'romgrk/barbar.nvim'
  -- maybe try this one one day? akinsho/bufferline.nvim
  -- use 'ap/vim-buftabline'
  -- This one is crashing vim when too many buffers are opened and I try to change buffer
  -- use 'jose-elias-alvarez/buftabline.nvim'
  -- Esse rainbow por algum motivo está quebrando a
  -- interpolação de strings em arquivos elixir ):
  -- use 'p00f/nvim-ts-rainbow'

  -- Coisas que tem a ver com cores e visual
  use 'rktjmp/lush.nvim'
  use 'tjdevries/colorbuddy.nvim'
  use 'norcalli/nvim-colorizer.lua'

  -- Esquema de cores
  use 'ayu-theme/ayu-vim'
  use 'Shatur/neovim-ayu'
  use 'folke/tokyonight.nvim'
end)
