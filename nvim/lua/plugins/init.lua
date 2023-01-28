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

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost lua/plugins/init.lua source <afile> | PackerCompile profile=true
  augroup end
]])

packer.init({
  -- display = {
  --   open_fn = function()
  --     return require('packer.util').float({ border = 'single' })
  --   end,
  -- },
  profile = {
    enable = true,
    threshold = 0,
  }
})

packer.startup(function(use)
  -- Without lazy loading
  -----------------------
  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim'
  use 'elixir-editors/vim-elixir'
  use 'kylechui/nvim-surround'
  use 'chrisgrieser/nvim-various-textobjs'
  -- Obs: Both tmux.nvim and Plenary are also NOT lazy loaded, but listed
  --      afterwards. Plenary appears in telescope dependencies.

  -- Colors and visuals
  ---------------------
  -- use 'folke/lsp-colors.nvim'
  -- use 'folke/tokyonight.nvim'
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    event = 'VimEnter',
    config = function() require('plugins.catppuccin') end,
  }
  use {
    'lewis6991/gitsigns.nvim',
    after = 'catppuccin',
    config = function() require('plugins.gitsigns') end,
  }
  use {
    'hoob3rt/lualine.nvim',
    after = 'catppuccin',
    config = function() require('plugins.lualine') end,
  }
  use {
    'romgrk/barbar.nvim',
    after = 'catppuccin',
    setup = function() vim.cmd([[let bufferline = get(g:, 'bufferline', {'icons': v:false,'no_name_title': '[No Name]'})]]) end,
    config = function() require('plugins.barbar') end,
  }
  use {
    'NvChad/nvim-colorizer.lua',
    cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer', 'ColorizerReloadAllBuffers', },
    config = function() require('plugins.colorizer') end,
  }

  -- Useful or somewhat useful commands
  -------------------------------------
  use {
    'numToStr/Comment.nvim',
    keys = {
      { 'n', 'gc', },
      { 'n', 'gb', },
      { 'v', 'gc', },
      { 'v', 'gb', },
    },
    config = function() require('plugins.Comment') end,
  }
  use {
    'kyazdani42/nvim-tree.lua',
    keys = require('plugins.nvim-tree').keys(),
    config = function() require('plugins.nvim-tree').setup() end,
  }
  use {
    'monaqa/dial.nvim',
    keys = {
      { 'n', '<C-a>' },
      { 'n', '<C-x>' },
      { 'v', '<C-a>' },
      { 'v', '<C-x>' },
      { 'v', 'g<C-a>' },
      { 'v', 'g<C-x>' },
    },
    config = function() require('plugins.dial') end,
  }
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    setup = function() require('plugins.undotree') end
  }

  -- Clojure things
  -----------------
  -- use { 'Olical/conjure', ft = { 'clojure' }, }
  -- use { 'guns/vim-sexp', ft = { 'clojure' }, }

  -- Telescope
  ------------
  use {
    'nvim-telescope/telescope.nvim',
    keys = require('plugins.telescope').keys(),
    -- Since some default LSP keybinds try to use telescope before
    -- standard vim.lsp calls, I added this "module" so telescope
    -- would be loaded when trying to use those keybindings.
    module = 'telescope',
    config = function() require('plugins.telescope').setup() end,
    requires = { 'nvim-lua/plenary.nvim', },
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    after = 'telescope.nvim',
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension somewhere AFTER the setup function:
    config = function() require('telescope').load_extension('fzf') end,
  }
  use {
    'debugloop/telescope-undo.nvim',
    after = 'telescope.nvim',
    config = function() require('telescope').load_extension('undo') end,
  }

  -- Tmux related plugins
  -----------------------
  -- This one is also used outside of tmux simply
  -- to switch panes. No lazy loading.
  use 'aserowy/tmux.nvim'
  use {
    'christoomey/vim-tmux-runner',
    cond = function() return os.getenv('TMUX') ~= nil end,
    cmd = { 'VtrAttachToPane', 'VtrSendCommand' }
  }

  -- LSP
  ------
  use { 'folke/neodev.nvim',                  module = 'neodev', }
  use { 'j-hui/fidget.nvim',                  module = 'fidget', }
  use { 'williamboman/mason.nvim',            event = 'BufRead', }
  use { 'williamboman/mason-lspconfig.nvim',  after = 'mason.nvim', }
  use { 'jose-elias-alvarez/typescript.nvim', after = 'mason.nvim', }
  use { 'neovim/nvim-lspconfig',              after = 'mason.nvim',
        config = function() require('plugins.lsp') end, }

  -- Testar esse aqui também, aproveitar que eu já uso o lualine.
  -- Alternativa para o fidget.
  -- use 'arkav/lualine-lsp-progress'
  -- use 'jose-elias-alvarez/null-ls.nvim'

  -- TreeSitter
  -------------
  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    event = 'BufEnter',
    config = function() require('plugins.tree-sitter') end,
  }
  use { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter', }
  use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter', }
  use { 'nvim-treesitter/playground',                  after = 'nvim-treesitter', }

  -- Completion and things that write in general
  ----------------------------------------------
  use { 'tpope/vim-ragtag', keys = '<C-x>', }
  use { 'mattn/emmet-vim', keys = '<C-y>', }
  use {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function() require('plugins.cmp') end,
  }
  use { 'hrsh7th/cmp-path',     after = 'nvim-cmp', }
  use { 'hrsh7th/cmp-buffer',   after = 'nvim-cmp', }
  use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp', }
  use { 'L3MON4D3/LuaSnip',     module = 'luasnip', config = function() require('plugins.luasnip') end, }
  use { 'onsails/lspkind-nvim', module = 'lspkind', }
  use { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' }

  -- Weird, but using lexima for endwise complete and putting new line + indent
  -- when, eg, pressing enter inside parens.
  -- I think nvim-autopairs should be able to do it, but having lexima as well
  -- is apparently make it buggy
  use { 'cohama/lexima.vim',     event = 'InsertEnter', config = function() require('plugins.lexima') end, }
  use { 'windwp/nvim-autopairs', event = 'InsertEnter', config = function() require('plugins.nvim-autopairs') end, }
  use { 'alvan/vim-closetag',    event = 'InsertEnter', config = function() require('plugins.vim-closetag') end, }

  if packer_bootstrap then
    packer.sync()
  end
end)
