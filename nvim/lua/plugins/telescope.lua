local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', function() TelescopeGitOrFindFiles() end, { noremap = true })
vim.keymap.set('n', '<C-f>', function() telescope_builtin.live_grep() end, { noremap = true })
vim.keymap.set('n', '<leader>P', function() telescope_builtin.buffers() end, { noremap = true })
vim.keymap.set('n', '<leader>h', function() telescope_builtin.oldfiles() end, { noremap = true })
-- vim.keymap.set('n', '<leader>zv', ':Telescope find_files cwd=/your/path/here/<CR>', { noremap = true })
vim.keymap.set('n', '<leader>zv', function() telescope_builtin.find_files({ cwd = vim.fn.stdpath('config') }) end, { noremap = true })

local actions = require('telescope.actions')

telescope.setup({
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

        -- I wanted to have a "faster scrolling", but pag up/down is too fast! :sweat_smile:
        -- ['<C-p>'] = 'results_scrolling_up',
        -- ['<C-n>'] = 'results_scrolling_down',
        ['<C-p>'] = actions.move_selection_previous + actions.move_selection_previous + actions.move_selection_previous,
        ['<C-n>'] = actions.move_selection_next + actions.move_selection_next + actions.move_selection_next,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    undo = { layout_config = { preview_width = 0.7, }, },
  },
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension somewhere AFTER the setup function:
telescope.load_extension('fzf')
telescope.load_extension('undo')

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
