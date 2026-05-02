local fzf = require('plugins.fzf-lua')

local function map_from_keys(keys)
  for _, k in ipairs(keys) do
    vim.keymap.set(k.mode, k.lhs, k.rhs, k.opts)
  end
end

local function r(path)
  return function()
    require(path)
  end
end

require('pack_wrap').call({
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
    disable = true,
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
    before = function()
      require('plugins.vim-matchup')
    end,
  },
  {
    -- Using mini.ai to fix specifically this
    -- https://www.reddit.com/r/neovim/comments/13c9ycn/comment/jjfjs1h/?context=3
    'echasnovski/mini.ai',
    version = vim.version.range('*'),
    after = function()
      require('plugins.mini.ai')
    end,
  },
  {
    'nvim-mini/mini.comment',
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
    after = function()
      map_from_keys(require('plugins.bufdelete'))
    end
  },
  {
    'eero-lehtinen/oklch-color-picker.nvim',
    after = function()
      vim.api.nvim_create_user_command('ColorHighlightToggle', function()
        require('oklch-color-picker').highlight.toggle()
      end, {})

      vim.keymap.set('n', '<leader>C', ':ColorHighlightToggle<CR>')
      vim.keymap.set('n', '<leader>V', ':ColorPickOklch<CR>')

      require('oklch-color-picker').setup({
        highlight = {
          enabled = false,
        },
      })
    end,
  },
  {
    'kyazdani42/nvim-tree.lua',
    after = function()
      map_from_keys(require('plugins.nvim-tree').keys)
      require('plugins.nvim-tree').setup()
    end
  },
  {
    'FabijanZulj/blame.nvim',
    after = function()
      require('plugins.blame')
    end,
  },
  {
    'sindrets/diffview.nvim',
    before = require('plugins.diffview').init,
    after = require('plugins.diffview').setup,
  },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- Tmux related plugins
  -----------------------
  {
    disable = true,
    'christoomey/vim-tmux-navigator',
    before = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')
      vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
      vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')
      vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>')
    end,
  },
  {
    disable = true,
    -- 'christoomey/vim-tmux-runner',
    'lucassperez/vim-tmux-runner',
    version = 'get-attached-pane',
  },

  -----------------------------------------------
  -----------------------------------------------
  -----------------------------------------------

  -- LSP
  ------
  {
    -- Create a cronjob with
    -- nvim --headless -c "lua require('mason')" -c 'MasonUpdate' -c 'qall'
    'williamboman/mason.nvim',
    r('lsp'),
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      {
        'wesleimp/stylua.nvim',
        hook = {
          kind = 'install',
          callback = function()
            vim.cmd('!cargo install stylua')
          end,
        },
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      {
        -- I placed the config call inside lua_ls config file.
        'folke/lazydev.nvim',
        filetype = 'lua',
      },
      {
        disable = false,
        'j-hui/fidget.nvim',
        r('plugins.fidget'),
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
    after = function ()
      require('plugins.nvim-treesitter')
    end,
    hook = {
      kind = 'update',
      callback = function()
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
    filetype = { 'eruby', 'elixir', 'eelixir', 'heex' },
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
  --   filetype = { 'html', 'css', 'eruby', 'heex', 'elixir', 'eelixir' },
  --   before = function()
  --     -- Command actually is leader+comma, so it is <C-x>,
  --     vim.cmd("let g:user_emmet_leader_key='<C-x>'")
  --   end,
  -- },
  {
    'hrsh7th/nvim-cmp',
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
    after = function()
      require('plugins.lexima')
    end,
  },
  {
    'windwp/nvim-autopairs',
    after = function()
      require('plugins.nvim-autopairs')
    end,
  },
  {
    'alvan/vim-closetag',
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
    before = fzf.before,
    after = fzf.after,
  },
})
