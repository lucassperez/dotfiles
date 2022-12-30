vim.api.nvim_set_keymap('n', '<C-p>', ':lua TelescopeGitOrFindFiles()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>P', ':Telescope buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':Telescope oldfiles<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>zv', ':Telescope find_files cwd=/home/lucas/dotfiles/nvim/<CR>', { noremap = true })

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup({
  pickers = {
    lsp_references = { show_line = false },
  },
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
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local telescope_builtin = require('telescope.builtin')

function TelescopeGitOrFindFiles(opts)
  local code = os.execute('git rev-parse --git-dir 2>/dev/null 1>&2')
  if code == 0 then
    telescope_builtin.git_files(opts)
  else
    telescope_builtin.find_files(opts)
  end
end

-- https://github.com/jchilders/dotfiles/blob/main/xdg_config/nvim/lua/core/highlights.lua
-- vim.cmd('autocmd ColorScheme * highlight TelescopeBorder         guifg=#3e4451')
-- vim.cmd('autocmd ColorScheme * highlight TelescopePromptBorder   guifg=#3e4451')
-- vim.cmd('autocmd ColorScheme * highlight TelescopeResultsBorder  guifg=#3e4451')
-- vim.cmd('autocmd ColorScheme * highlight TelescopePreviewBorder  guifg=#525865')
