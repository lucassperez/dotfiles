vim.api.nvim_set_keymap('n', '<C-p>', ':lua telescopeGitOrFindFiles()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':Telescope oldfiles<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>zv', ':Telescope find_files cwd=/home/lucas/dotfiles/nvim/<CR>', { noremap = true })

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  defaults = {
    layout_config = {
      vertical = { width = 0.99, height = 0.80 },
      horizontal = { width = 0.99, height = 0.80 },
    },
    mappings = {
      i = {
        ['<C-k>'] = 'move_selection_previous',
        ['<C-j>'] = 'move_selection_next',
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = 'smart_case',        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local telescope_builtin = require('telescope.builtin')

function telescopeGitOrFindFiles(opts)
  if os.execute('git rev-parse --git-dir 2>/dev/null 1>&2') then
    telescope_builtin.git_files(opts)
  else
    telescope_builtin.find_files(opts)
  end
end
