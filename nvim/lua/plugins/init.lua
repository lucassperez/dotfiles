vim.cmd('let g:sexp_enable_insert_mode_mappings = 0')

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

local status, packer = pcall(require, 'packer')
if not status then
  return
end

packer.init({
  compile_path = vim.fn.stdpath('config')..'/packer/packer_compiled.lua',
})

return packer.startup(function()
  use 'wbthomason/packer.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end

  use 'elixir-editors/vim-elixir'

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
  use 'antoinemadec/FixCursorHold.nvim'
  vim.g.cursorhold_updatetime = 100
  use 'kyazdani42/nvim-tree.lua'
  use 'airblade/vim-gitgutter'
  use 'alvan/vim-closetag'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'nvim-lua/plenary.nvim'

  -- Coisas LSP e TreeSitter
  use 'neovim/nvim-lspconfig'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  use { 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate', }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'
  -- use 'folke/lsp-colors.nvim'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'

  use 'L3MON4D3/LuaSnip'

  use 'onsails/lspkind-nvim'

  -- Ajudinha visual
  use 'hoob3rt/lualine.nvim'
  use 'romgrk/barbar.nvim'
  -- use { 'romgrk/barbar.nvim', requires = { 'kyazdani42/nvim-web-devicons' }, }
  -- use 'p00f/nvim-ts-rainbow'

  -- Coisas que tem a ver com cores e visual
  use 'rktjmp/lush.nvim'
  use 'tjdevries/colorbuddy.nvim'
  use 'norcalli/nvim-colorizer.lua'

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
end)
