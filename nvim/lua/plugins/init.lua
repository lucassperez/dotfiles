local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- https://github.com/yegappan/mru tentar esse qualquer dias desses
-- https://github.com/neoclide/redismru.vim ou esse
return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'folke/lsp-colors.nvim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

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
  -- use 'mhinz/vim-startify'
  -- use 'windwp/nvim-ts-autotag'
  use 'alvan/vim-closetag'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  -- use 'abecodes/tabout.nvim'
  use 'nvim-lua/plenary.nvim'

  -- Coisas LSP e TreeSitter
  use 'neovim/nvim-lspconfig'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'

  use 'L3MON4D3/LuaSnip'

  use 'onsails/lspkind-nvim'

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
  use 'p00f/nvim-ts-rainbow'

  -- Coisas que tem a ver com cores e visual
  use 'rktjmp/lush.nvim'
  use 'tjdevries/colorbuddy.nvim'
  use 'norcalli/nvim-colorizer.lua'

  -- Esquema de cores
  use 'ayu-theme/ayu-vim'
  use 'Shatur/neovim-ayu'
  use 'folke/tokyonight.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
