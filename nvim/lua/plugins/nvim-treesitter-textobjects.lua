return {
  setup = function()
    require('nvim-treesitter-textobjects').setup({
      select = {
        enable = true,
        lookahead = true,
      },
      move = {
        enable = true,
        set_jumps = true,
      },
      -- lsp_interop = {
      --   enable = true,
      --   border = 'none',
      --   peek_definition_code = {
      --     -- This is interesting when you don't want to go to definition, I guess
      --     ['\\pk'] = '@function.outer',
      --     ['\\pK'] = '@class.outer',
      --   },
      -- },
    })
  end,
  create_keymaps = function()
    -- Select
    vim.keymap.set({ 'x', 'o' }, 'af', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'if', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
    end)
    -- You can also use captures from other query groups like `locals.scm`
    vim.keymap.set({ 'x', 'o' }, 'as', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
    end)

    -- Swap
    vim.keymap.set('n', ']a', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end)
    vim.keymap.set('n', '[a', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
    end)

    -- Move
    -- Instead of goto_next_start or goto_next_end, we can use just goto_next
    -- to go to next end or start, whichever is closer
    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
      require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
      require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
    end)

    vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']Z', function()
      require('nvim-treesitter-textobjects.move').goto_next_end('@fold', 'folds')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[z', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@fold', 'folds')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[Z', function()
      require('nvim-treesitter-textobjects.move').goto_previous_end('@fold', 'folds')
    end)

    -- Go to either the start or the end, whichever is closer.
    -- Use if you want more granular movements
    -- vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
    --   require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
    -- end)
    -- vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
    --   require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects')
    -- end)
  end,
}
