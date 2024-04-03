local function keys()
  return {
    {
      mode = 'n',
      desc = '[Oil] Abre o oil numa janela flutuante',
      '<leader>b',
      function()
        require('oil').toggle_float()
      end,
    },
  }
end

local function setup()
  require('oil').setup({
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`
    -- To be honest, it doesn't work even when set to true.
    -- It does not work because Oil is lazy loaded.
    -- If not, it will work correctly.
    default_file_explorer = false,
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = '', nowait = true })
    -- Additionally, if it is a string that matches 'actions.<name>',
    -- it will use the mapping at require('oil.actions').<name>
    -- Set to `false` to remove a keymap
    -- See :help oil-actions for a list of all available actions
    keymaps = {
      ['<C-l>'] = 'actions.select',
      ['<C-h>'] = 'actions.parent',
      ['<C-s>'] = 'actions.select_split',
      ['R'] = 'actions.refresh',
      ['<C-q>'] = function()
        -- Saves without asking
        require('oil').save({ confirm = false })
        require('oil').close()
      end,
      ['<C-n>'] = function()
        require('oil').save({ confirm = true })
        require('oil').close()
      end,
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
    -- Configuration for the floating window in oil.open_float
    float = {
      -- Padding around the floating window
      padding = 2,
      max_width = 150,
      max_height = 0,
      border = 'rounded',
      win_options = {
        winblend = 10,
      },
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      -- override = function(conf) return conf end,
    },
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'oil://*',
    callback = function()
      vim.keymap.set('n', 'Q', function()
        local oil = require('oil')
        oil.save()
        oil.close()
      end, { buffer = true, desc = '[Oil] Salva e sai de um buffer do oil' })
    end,
    desc = '[Oil] Create Q keymap to save and exit oil',
  })
end

return {
  keys = keys,
  setup = setup,
}
