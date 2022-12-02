require('nvim-treesitter.configs').setup({
  -- ensure_installed can be 'all' or a list of languages { 'python', 'javascript' }
  ensure_installed = {'lua', 'bash', 'javascript', 'ruby', 'go', 'java', 'clojure', 'comment'},

  highlight = { -- enable highlighting for all file types
    enable = true, -- you can also use a table with list of langs here (e.g. { 'python', 'javascript' })
    disable = {'vue'},
    custom_captures = {
      ['heredoc_content'] = 'TSComment',
    },
  },
  indent = {
    -- Funcionalidade experimental!
    enable = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<CR>',
      show_help = '?',
    },
  },
  -- autotag = {
  --   enable = true,
  --   filetypes = { 'html', 'eelixir' }
  -- },
  context_commentstring = {
    enable = true,
    config = {
      eelixir = '<%# %s %>',
    }
  },
  rainbow = {
    -- https://github.com/p00f/nvim-ts-rainbow/issues/30
    enable = true,
    disable = function(p)
        if p == 'clojure' then return false end
        return true
      end,
    extended_mode = true,
    max_file_lines = 1000,
    termcolors = {'209','40','170','220','208','205', },
    -- colors = {'#ff875f', '#00d700', '#d75fd7', '#ffd700', '#ff8700', '#ff5faf', }
    colors = {'#ff875f', '#00d700', '#d75fd7', '#ffd700', }
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
      swap_next = { [']a'] = '@parameter.inner', },
      swap_previous = { ['[a'] = '@parameter.inner', },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { [']f'] = '@function.outer', },
      goto_next_end = { [']F'] = '@function.outer', },
      goto_previous_start = { ['[f'] = '@function.outer', },
      goto_previous_end = { ['[F'] = '@function.outer', },
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
