require('nvim-treesitter.configs').setup({
  -- ensure_installed can be 'all' or a list of languages { 'python', 'javascript' }
  ensure_installed = {
    'lua',
    'comment',
    'vim',
    'vimdoc',
    'bash',
    'query',
  },
  sync_install = false,
  ignore_install = {},
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,
  highlight = {
    enable = true,
    disable = { 'vue' },
    additional_vim_regex_highlighting = { 'elixir' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-Space>',
      node_incremental = '<C-Space>',
      scope_incremental = '<C-s>',
      node_decremental = '<Backspace>',
    },
  },
  indent = {
    -- Funcionalidade experimental!
    enable = false,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        -- ['af'] = {
        --   elixir = '(function) @function.outer',
        --   javascript = '@function.outer'
        -- },
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        -- Or you can define your own textobjects like this
        -- ['iF'] = {
        --   python = '(function_definition) @function',
        --   cpp = '(function_definition) @function',
        --   c = '(function_definition) @function',
        --   java = '(method_declaration) @function',
        -- },
      },
    },
    swap = {
      enable = true,
      swap_next = { [']a'] = '@parameter.inner' },
      swap_previous = { ['[a'] = '@parameter.inner' },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { [']f'] = '@function.outer' },
      goto_next_end = { [']F'] = '@function.outer' },
      goto_previous_start = { ['[f'] = '@function.outer' },
      goto_previous_end = { ['[F'] = '@function.outer' },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = { -- This is interesting when you don't want to go to definition, I guess
        ['\\pk'] = '@function.outer',
        ['\\pK'] = '@class.outer',
      },
    },
  },
})

-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldlevelstart = 99
