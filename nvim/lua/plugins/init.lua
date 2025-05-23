local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, 'lazy')
if not ok then
  print('Could not require lazy!')
  print('Exiting from plugins/init.lua')
  return
end

local opts = {
  lockfile = vim.fn.stdpath('config') .. '/plugins-lock-lazy.json',
  install = {
    colorscheme = { 'catppuccin', 'habamax' },
  },
  ui = {
    icons = {
      cmd = '👊',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙️',
      keys = '🔑',
      plugin = '🔌',
      runtime = '🏃',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
      import = '📦',
      require = '🚚',
    },
  },
}

local plugins = {
  {
    'FabijanZulj/blame.nvim',
    cmd = { 'BlameToggle' },
    config = function()
      require('plugins.blame')
    end,
  },
  -- Without lazy loading
  -----------------------
  -- Catppuccin is also not being lazy loaded.
  'elixir-editors/vim-elixir',
  {
    'kylechui/nvim-surround',
    config = function()
      require('plugins.nvim-surround')
    end,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    config = function()
      require('plugins.nvim-various-textobjs')
    end,
  },

  -- Using mini.ai to fix specifically this
  -- https://www.reddit.com/r/neovim/comments/13c9ycn/comment/jjfjs1h/?context=3
  {
    'echasnovski/mini.ai',
    version = '*',
    config = function()
      require('plugins.mini.ai')
    end,
  },

  -- Colors and visuals
  ---------------------
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('plugins.catppuccin')
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = function()
      require('plugins.gitsigns')
    end,
  },
  {
    -- Will need sometime like one of these to use with it:
    -- https://github.com/ojroques/nvim-bufdel
    -- https://github.com/famiu/bufdelete.nvim
    -- https://github.com/moll/vim-bbye
    -- 'willothy/nvim-cokeline',
    -- dir = '~/trb/FORKS/nvim-cokeline',
    'lucassperez/nvim-cokeline',
    branch = 'buffer-picker-indexes',
    enabled = true,
    config = function()
      require('plugins.nvim-cokeline')
    end,
    dependencies = 'nvim-lua/plenary.nvim',
  },
  -- https://github.com/uga-rosa/ccc.nvim/blob/main/doc/ccc.txt
  -- Maybe change colorizer for this?
  -- Or this? https://github.com/brenoprata10/nvim-highlight-colors
  {
    'NvChad/nvim-colorizer.lua',
    cmd = {
      'ColorizerToggle',
      'ColorizerAttachToBuffer',
      'ColorizerDetachFromBuffer',
      'ColorizerReloadAllBuffers',
    },
    config = function()
      require('plugins.nvim-colorizer')
    end,
  },

  -- This is both "color and visuals" and "useful or somewhat useful commands"
  {
    'andymass/vim-matchup',
    event = { 'BufRead', 'BufNew' },
    init = function()
      require('plugins.vim-matchup')
    end,
  },

  -- Useful or somewhat useful commands
  -------------------------------------
  -- {
  --   'mg979/vim-visual-multi',
  --   lazy = true,
  --   keys = require('plugins.vim-visual-multi').keys,
  --   init = require('plugins.vim-visual-multi').init,
  -- },
  {
    'numToStr/Comment.nvim',
    keys = {
      { mode = { 'n', 'v', 'o' }, 'gc', desc = '[Comment] Toggle line comments' },
      { mode = { 'n', 'v', 'o' }, 'gb', desc = '[Comment] Toggle block comments' },
      { mode = 'o', 'u' },
      { mode = 'n', 'yc' },
      { mode = 'n', 'yC' },
    },
    config = function()
      require('plugins.Comment')
    end,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      init = function()
        vim.g.skip_ts_context_commentstring_module = true
      end,
      config = function()
        -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/82
        require('ts_context_commentstring').setup({ enable_autocmd = false })
      end,
    },
  },
  {
    'famiu/bufdelete.nvim',
    keys = require('plugins.bufdelete'),
  },
  {
    'kyazdani42/nvim-tree.lua',
    keys = require('plugins.nvim-tree').keys,
    config = require('plugins.nvim-tree').setup,
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { mode = { 'n', 'v' }, '<C-a>', desc = '[Dial] plugin dial C-a' },
      { mode = { 'n', 'v' }, '<C-x>', desc = '[Dial] plugin dial C-x' },
      { mode = 'v', 'g<C-a>', desc = '[Dial] plugin dial g-C-a' },
      { mode = 'v', 'g<C-x>', desc = '[Dial] plugin dial g-C-x' },
    },
    config = function()
      require('plugins.dial')
    end,
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    init = function()
      require('plugins.undotree')
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = require('plugins.diffview').cmd,
    init = require('plugins.diffview').init,
    config = require('plugins.diffview').setup,
  },

  -- Clojure things
  -----------------
  -- { 'Olical/conjure', ft = { 'clojure' }, },
  -- { 'guns/vim-sexp', ft = { 'clojure' }, },

  -- Tmux related plugins
  -----------------------
  {
    'christoomey/vim-tmux-navigator',
    cmd = { 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight' },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')
      vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
      vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')
      vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>')
    end,
  },
  {
    -- 'christoomey/vim-tmux-runner',
    'lucassperez/vim-tmux-runner',
    branch = 'get-attached-pane',
    cmd = {
      'VtrAttachToPane',
      'VtrSendCommand',
      'VtrSendCtrlD',
      'VtrSendCtrlC',
    },
  },

  -- LSP
  ------
  {
    'williamboman/mason.nvim',
    event = { 'BufRead', 'BufNewFile' },
    cmd = 'Mason',
    config = function()
      require('plugins.lsp')
    end,
    build = ':MasonUpdate',
    dependencies = {
      {
        'wesleimp/stylua.nvim',
        build = 'cargo install stylua',
        dependencies = 'nvim-lua/plenary.nvim',
        -- Since os.execute may return nil, the LSP was annoyed that I could be
        -- using a possibly not boolean value and enabled wants a boolean, I
        -- used this "not not" to cast it to boolean.
        -- enabled = function () return not not os.execute('cargo -v 2>/dev/null 1>&2') end
      },
      'folke/neodev.nvim',
      'williamboman/mason-lspconfig.nvim',
      'jose-elias-alvarez/typescript.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      { 'j-hui/fidget.nvim', tag = 'legacy' },
    },
  },

  -- Testar esses aqui também, aproveitar que eu já uso o lualine.
  -- Alternativas para o fidget.
  -- 'arkav/lualine-lsp-progress',
  -- 'linrongbin16/lsp-progress.nvim',
  -- 'jose-elias-alvarez/null-ls.nvim',
  -- https://github.com/jay-babu/mason-nvim-dap.nvim
  -- https://github.com/jay-babu/mason-null-ls.nvim

  -- TreeSitter
  -------------
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'FileType',
    cmd = { 'TSInstall', 'TSUninstall', 'TSInstallInfo', 'TSInstallFromGrammar' },
    config = function()
      require('plugins.tree-sitter')
    end,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'hiphish/rainbow-delimiters.nvim',
        init = function()
          require('plugins.rainbow-delimiters')
        end,
      },
    },
  },

  -- Completion and things that write in general
  ----------------------------------------------

  -- Both ragtag and emmet, I can't seem to lazy load them correctly
  -- Emmet can be replaced with emmet_ls (LSP), but ragtag...? ):
  -- Or maybe I should use emmet_language_server instead.
  -- Theoretically there is this to enhance emmet_language_server: https://github.com/olrtg/nvim-emmet
  {
    'tpope/vim-ragtag',
    filetype = { 'eruby', 'elixir', 'eelixir', 'heex' },
    enabled = true,
    init = function()
      -- https://github.com/tpope/vim-ragtag/blob/master/doc/ragtag.txt
      vim.cmd([[
        inoremap <M-o>       <Esc>o
        inoremap <C-j>       <Down>
        let g:ragtag_global_maps = 1
      ]])
    end,
  },
  {
    'mattn/emmet-vim',
    filetype = { 'html', 'css', 'eruby', 'heex', 'elixir', 'eelixir' },
    enabled = false,
    init = function()
      -- Command actually is leader+comma, so it is <C-x>,
      vim.cmd("let g:user_emmet_leader_key='<C-x>'")
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      require('plugins.cmp')
    end,
    dependencies = {
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      {
        'L3MON4D3/LuaSnip',
        config = function()
          require('plugins.luasnip')
        end,
        -- 'https://github.com/rafamadriz/friendly-snippets',
        dependencies = 'saadparwaiz1/cmp_luasnip',
      },
    },
  },

  -- Weird, but using lexima for endwise complete and putting new line + indent
  -- when, eg, pressing enter inside parens.
  -- I think nvim-autopairs should be able to do it, but having lexima as well
  -- is apparently making it buggy.
  {
    'cohama/lexima.vim',
    enabled = true,
    event = 'InsertEnter',
    config = function()
      require('plugins.lexima')
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('plugins.nvim-autopairs')
    end,
  },
  -- Suddenly close tag does not work with lazy loading anymore... ):
  {
    'alvan/vim-closetag',
    enabled = true,
    -- event = 'InsertEnter',
    init = function()
      require('plugins.vim-closetag')
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    enabled = false,
    config = function()
      -- Ensure nvim-ts-autotag is properly set up
      require('nvim-ts-autotag').setup()
    end,
  },
}

-- Fuzzy Finder, FzfLua or Telescope
-------------------------------------
local ok_fuzz, fuzzy_finder = pcall(require, 'plugins.FUZZY_FINDER')
if ok_fuzz and fuzzy_finder ~= nil then table.insert(plugins, fuzzy_finder.lazyPluginSpec) end

lazy.setup(plugins, opts)
