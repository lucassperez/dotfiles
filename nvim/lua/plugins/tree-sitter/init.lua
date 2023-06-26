vim.keymap.set('n', '<leader>m', ':TSHighlightCapturesUnderCursor<CR>', { desc = 'Mostra o grupo de destaque (highlight) da coisa/palavra embaixo do cursor', })

local function requireSpecificFiles()
  -- These files have to be required after the configs.setup call,
  -- but I also don't want to have these requires at the bottom of
  -- this file, because I prefer that the setup is "the last thing"
  -- in the file, since it is so big, and anything after it might
  -- be easily missed when reading configs again.
  require('plugins.tree-sitter.typescript')
  -- require('plugins.tree-sitter.elixir')
end

require('nvim-treesitter.configs').setup({
  -- ensure_installed can be 'all' or a list of languages { 'python', 'javascript' }
  ensure_installed = {
    'lua',
    'comment',
    'vim',
    'vimdoc',
    'bash',
  },
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,
  highlight = {
    enable = true,
    disable = { 'vue' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = '<C-Space>',
      node_incremental  = '<C-Space>',
      scope_incremental = '<C-s>',
      node_decremental  = '<Backspace>',
    },
  },
  indent = {
    -- Funcionalidade experimental!
    enable = false,
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
    enable_autocmd = false,
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

requireSpecificFiles()
