local function keys()
  return {
    {
      mode = 'n',
      desc = 'Abre o oil numa janela flutuante',
      '<leader>b',
      function() require('oil').open_float() end,
    },
  }
end

local function setup()
  require('oil').setup({
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`
    -- To be honest, it doesn't work even when set to true.
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
      ['<C-q>'] = 'actions.close',
      ['<leader>-'] = 'actions.close',
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'oil://*',
    callback = function ()
      vim.keymap.set('n', 'Q', function()
        local oil = require('oil')
        oil.save()
        oil.close()
      end, { buffer = true, desc = 'Salva e sai de um buffer do oil', })
    end
  })
end

return {
  keys = keys,
  setup = setup,
}
