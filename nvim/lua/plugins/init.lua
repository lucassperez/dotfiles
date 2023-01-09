local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

local ok, packer = pcall(require, 'packer')
if not ok then
  print('Could not require packer!')
  print('Exiting')
  return
end

packer.init({
  compile_path = vim.fn.stdpath('config')..'/packer/packer_compiled.lua',
})

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'elixir-editors/vim-elixir'

  use 'mbbill/undotree'

  -- Clojure things
  -- use { 'Olical/conjure', ft = { 'clojure' }, }
  -- use { 'guns/vim-sexp', ft = { 'clojure' }, }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'}, },
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use 'christoomey/vim-tmux-navigator'
  use 'christoomey/vim-tmux-runner'
  -- Weird, but using lexima for endwise complete and putting new line + indent
  -- when, eg, pressing enter inside parens.
  -- I think nvim-autopairs should be able to do it, but having lexima as well
  -- is apparently make it buggy
  use 'cohama/lexima.vim'
  use 'windwp/nvim-autopairs'
  use 'kylechui/nvim-surround'
  use 'tpope/vim-ragtag'
  use 'numToStr/Comment.nvim'
  use 'mattn/emmet-vim'
  use 'kyazdani42/nvim-tree.lua'
  use 'lewis6991/gitsigns.nvim'
  use 'alvan/vim-closetag'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'nvim-lua/plenary.nvim'

  -- Coisas LSP e TreeSitter
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
    },
  }

  -- use 'folke/lsp-colors.nvim'
  -- Testar esse aqui também, aproveitar que eu já uso o lualine.
  -- Alternativa para o fidget.
  -- use 'arkav/lualine-lsp-progress'

  use 'jose-elias-alvarez/null-ls.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    requires = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'onsails/lspkind-nvim',
      'folke/neodev.nvim',
    },
  }

  -- Ajudinha visual
  use 'hoob3rt/lualine.nvim'
  use 'romgrk/barbar.nvim'
  -- use { 'romgrk/barbar.nvim', requires = { 'kyazdani42/nvim-web-devicons' }, }
  -- use 'p00f/nvim-ts-rainbow'

  -- Coisas que tem a ver com cores e visual
  use 'rktjmp/lush.nvim'
  use 'tjdevries/colorbuddy.nvim'
  -- use 'norcalli/nvim-colorizer.lua'
  use 'NvChad/nvim-colorizer.lua'

  -- Esquema de cores
  -- use 'ayu-theme/ayu-vim'
  -- use 'Shatur/neovim-ayu'
  -- use 'folke/tokyonight.nvim'
  -- use 'EdenEast/nightfox.nvim'
  use { 'catppuccin/nvim', as = 'catppuccin', }
  -- use {
  --   'projekt0n/github-nvim-theme',
  --   -- config = function()
  --   --   require('github-theme').setup({})
  --   -- end,
  -- }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
