local function telescope_builtin()
  return require('telescope.builtin')
end
local function menufacture()
  return require('telescope').extensions.menufacture
end

local function telescopeGitOrFindFiles(opts)
  opts = opts or {}

  -- https://www.reddit.com/r/neovim/comments/141k38i/telescope_how_to_search_project_directory/
  local root = vim.fn.system('git rev-parse --show-toplevel')
  if vim.v.shell_error == 0 then
    opts.show_untracked = true
    opts.cwd = opts.cwd or string.gsub(root, '\n', '')
    menufacture().git_files(opts)
  else
    menufacture().find_files(opts)
  end
end

local function keys()
  return {
    {
      mode = 'n',
      desc = '[Telescope] Abre telescope git ou find files',
      '<C-p>',
      function()
        telescopeGitOrFindFiles()
      end,
      { noremap = true },
    },
    {
      mode = 'n',
      desc = '[Telescope] Abre telescope live grep',
      '<C-f>',
      function()
        -- https://www.reddit.com/r/neovim/comments/141k38i/telescope_how_to_search_project_directory/
        local root = vim.fn.system('git rev-parse --show-toplevel')
        if vim.v.shell_error == 0 then
          menufacture().live_grep({ cwd = string.gsub(root, '\n', '') })
        else
          menufacture().live_grep()
        end
      end,
      { noremap = true },
    },
    {
      mode = 'n',
      desc = '[Telescope] Abre telescope buffers',
      '<leader>p',
      function()
        telescope_builtin().buffers()
      end,
      { noremap = true },
    },
    {
      mode = 'n',
      desc = '[Telescope] Abre telescope old files',
      '<leader>h',
      function()
        telescope_builtin().oldfiles()
      end,
      { noremap = true },
    },
    {
      mode = 'n',
      desc = '[Telescope] Abre telescope find files no caminho de config do nvim',
      '<leader>zv',
      function()
        menufacture().find_files({ cwd = vim.fn.stdpath('config'), show_untracked = true })
      end,
      { noremap = true },
    },
  }
end

local function setup()
  local telescope = require('telescope')
  -- local actions = require('telescope.actions')

  telescope.setup({
    pickers = {
      lsp_references = { show_line = false },
      lsp_implementations = { show_line = false },
      lsp_definitions = { show_line = false },
      -- diagnostics = { path_display = 'hidden' },
    },
    defaults = {
      layout_config = {
        vertical = { width = 0.99, height = 0.80 },
        horizontal = { width = 0.99, height = 0.80 },
      },
      mappings = {
        i = {
          ['<C-h>'] = 'which_key',

          ['<C-k>'] = 'move_selection_previous',
          ['<C-j>'] = 'move_selection_next',

          -- I wanted to have a "faster scrolling", but pag up/down is too fast! :sweat_smile:
          -- ['<C-p>'] = 'results_scrolling_up',
          -- ['<C-n>'] = 'results_scrolling_down',
          -- ['<C-p>'] = actions.move_selection_previous + actions.move_selection_previous + actions.move_selection_previous,
          -- ['<C-n>'] = actions.move_selection_next + actions.move_selection_next + actions.move_selection_next,
        },
        n = {
          ['m'] = 'toggle_selection',
        },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or 'ignore_case' or 'respect_case'
        -- the default case_mode is 'smart_case'
      },
      undo = { layout_config = { preview_width = 0.7 } },
    },
  })

  -- https://github.com/jchilders/dotfiles/blob/main/xdg_config/nvim/lua/core/highlights.lua
  -- vim.cmd('autocmd ColorScheme * highlight TelescopeBorder         guifg=#3e4451')
  -- vim.cmd('autocmd ColorScheme * highlight TelescopePromptBorder   guifg=#3e4451')
  -- vim.cmd('autocmd ColorScheme * highlight TelescopeResultsBorder  guifg=#3e4451')
  -- vim.cmd('autocmd ColorScheme * highlight TelescopePreviewBorder  guifg=#525865')
end

return {
  keys = keys,
  setup = setup,
}
