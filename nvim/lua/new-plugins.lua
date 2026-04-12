local pw = require('pack_wrap')

local fuzzy_finder = require('plugins.FUZZY_FINDER')

local function r(path)
  return function()
    require(path)
  end
end

pw.prepare({
  -- Colors and visuals
  -- Main UI building
  ---------------------
  {
    'catppuccin/nvim',
    r('plugins.catppuccin'),
    name = 'catppuccin',
  },
  {
    'lewis6991/gitsigns.nvim',
    r('plugins.gitsigns'),
  },
  {
    'lucassperez/nvim-cokeline',
    r('plugins.nvim-cokeline'),
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  'elixir-editors/vim-elixir',

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- Code editing actions
  -----------------------
  {
    'kylechui/nvim-surround',
    after = function()
      require('plugins.nvim-surround')
    end,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    after = function()
      require('plugins.nvim-various-textobjs')
    end,
  },
  {
    'andymass/vim-matchup',
    lazy = {
      events = { 'BufRead', 'BufNew' },
    },
    before = function()
      require('plugins.vim-matchup')
    end,
  },
  {
    -- Using mini.ai to fix specifically this
    -- https://www.reddit.com/r/neovim/comments/13c9ycn/comment/jjfjs1h/?context=3
    'echasnovski/mini.ai',
    -- name = 'mini.ai',
    version = vim.version.range('*'),
    after = function()
      require('plugins.mini.ai')
    end,
  },
  {
    'nvim-mini/mini.comment',
    -- name = 'mini.comment',
    version = vim.version.range('*'),
    after = function()
      require('plugins.mini.comment')
    end,
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        after = function()
          require('ts_context_commentstring').setup({ enable_autocmd = false })
        end,
      },
    },
  },
  {
    'monaqa/dial.nvim',
    -- keymaps = {
    --   { mode = { 'n', 'v' }, lhs = '<C-a>', desc = '[Dial] plugin dial C-a' },
    --   { mode = { 'n', 'v' }, lhs = '<C-x>', desc = '[Dial] plugin dial C-x' },
    --   { mode = 'v', lhs = 'g<C-a>', desc = '[Dial] plugin dial g-C-a' },
    --   { mode = 'v', lhs = 'g<C-x>', desc = '[Dial] plugin dial g-C-x' },
    -- },
    after = function()
      require('plugins.dial')
    end,
  },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- Commands and features
  ------------------------
  {
    'famiu/bufdelete.nvim',
    -- keys = require('plugins.bufdelete'),
  },
  {
    'eero-lehtinen/oklch-color-picker.nvim',
    before = function()
      vim.api.nvim_create_user_command('ColorHighlightToggle', function()
        require('oklch-color-picker').highlight.toggle()
      end, {})
    end,
    after = function()
      require('oklch-color-picker').setup({
        highlight = {
          enabled = false,
        },
      })
    end,
    -- keys = {
    --   vim.keymap.set('n', '<Leader>C', ':ColorHighlightToggle<CR>'),
    --   vim.keymap.set('n', '<Leader>V', ':ColorPickOklch<CR>'),
    -- },
  },
  {
    'kyazdani42/nvim-tree.lua',
    -- keys = require('plugins.nvim-tree').keys,
    after = require('plugins.nvim-tree').setup,
  },
  {
    'FabijanZulj/blame.nvim',
    -- cmd = { 'BlameToggle' },
    after = function()
      require('plugins.blame')
    end,
  },
  {
    'sindrets/diffview.nvim',
    -- cmd = require('plugins.diffview').cmd,
    before = require('plugins.diffview').init,
    after = require('plugins.diffview').setup,
  },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- Tmux related plugins
  -----------------------
  {
    'christoomey/vim-tmux-navigator',
    -- cmd = { 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight' },
    before = function()
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
    version = 'get-attached-pane',
    cmd = {
      'VtrAttachToPane',
      'VtrSendCommand',
      'VtrSendCtrlD',
      'VtrSendCtrlC',
    },
  },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- LSP
  ------
  {
    'williamboman/mason.nvim',
    after = function()
      require('plugins.lsp')
    end,
    hook = {
      kind = 'update',
      callback = function()
        vim.cmd('MasonUpdate')
        require('plugins.lsp')
      end,
    },
    dependencies = {
      {
        'wesleimp/stylua.nvim',
        hook = {
          kind = 'update',
          callback = function()
            vim.cmd('!cargo install stylua')
          end,
        },
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      {
        'folke/lazydev.nvim',
        -- ft = 'lua',
        after = function()
          require('lazydev').setup({
            library = {
              {
                path = '${3rd}/luv/library',
                words = { 'vim%.uv' },
              },
            },
          })
        end,
      },
      'williamboman/mason-lspconfig.nvim',
      'jose-elias-alvarez/typescript.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      {
        'j-hui/fidget.nvim',
        after = function()
          require('plugins.fidget')
        end,
      },
    },
  },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- TreeSitter
  -------------
  {
    src = 'nvim-treesitter/nvim-treesitter',
    version = 'main',
    hook = {
      kind = 'update',
      function()
        vim.cmd('TSUpdate')
        require('plugins.nvim-treesitter')
      end,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    version = 'main',
    before = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
  },
  {
    'hiphish/rainbow-delimiters.nvim',
    after = function()
      require('plugins.rainbow-delimiters')
    end,
  },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- Completion and things that write in general
  ----------------------------------------------
  {
    'tpope/vim-ragtag',
    -- filetype = { 'eruby', 'elixir', 'eelixir', 'heex' },
    before = function()
      -- https://github.com/tpope/vim-ragtag/blob/master/doc/ragtag.txt
      vim.cmd([[
      inoremap <M-o>       <Esc>o
      inoremap <C-j>       <Down>
      let g:ragtag_global_maps = 1
      ]])
    end,
  },
  -- {
  --   'mattn/emmet-vim',
  --   -- filetype = { 'html', 'css', 'eruby', 'heex', 'elixir', 'eelixir' },
  --   before = function()
  --     -- Command actually is leader+comma, so it is <C-x>,
  --     vim.cmd("let g:user_emmet_leader_key='<C-x>'")
  --   end,
  -- },
  {
    'hrsh7th/nvim-cmp',
    -- event = 'InsertEnter',
    after = function()
      require('plugins.cmp')
    end,
    dependencies = {
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      {
        'L3MON4D3/LuaSnip',
        after = function()
          require('plugins.luasnip')
        end,
      },
      -- 'https://github.com/rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',
    },
  },
  {
    -- Weird, but using lexima for endwise complete and putting new line + indent
    -- when, eg, pressing enter inside parens.
    -- I think nvim-autopairs should be able to do it, but having lexima as well
    -- is apparently making it buggy.
    'cohama/lexima.vim',
    -- event = 'InsertEnter',
    after = function()
      require('plugins.lexima')
    end,
  },
  {
    'windwp/nvim-autopairs',
    -- event = 'InsertEnter',
    after = function()
      require('plugins.nvim-autopairs')
    end,
  },
  {
    'alvan/vim-closetag',
    -- event = 'InsertEnter',
    before = function()
      require('plugins.vim-closetag')
    end,
  },
  -- {
  --   'windwp/nvim-ts-autotag',
  --   enabled = false,
  --   after = function()
  --     require('nvim-ts-autotag').setup()
  --   end,
  -- },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- FzfLua
  ---------
  {
    'ibhagwan/fzf-lua',
    before = fuzzy_finder.lazyPluginSpec.init,
    after = fuzzy_finder.lazyPluginSpec.config,
  },
})

pw.execute()
pw.create_user_commands()
