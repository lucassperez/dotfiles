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
      history = {
        path = vim.fn.stdpath('data') .. '/databases/telescope_history.sqlite3',
        limit = 100,
      },
      mappings = {
        i = {
          ['<C-p>'] = 'cycle_history_prev',
          ['<C-n>'] = 'cycle_history_next',

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
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
    },
  })

  -- https://github.com/jchilders/dotfiles/blob/main/xdg_config/nvim/lua/core/highlights.lua
  -- vim.cmd('autocmd ColorScheme * highlight TelescopeBorder         guifg=#3e4451')
  -- vim.cmd('autocmd ColorScheme * highlight TelescopePromptBorder   guifg=#3e4451')
  -- vim.cmd('autocmd ColorScheme * highlight TelescopeResultsBorder  guifg=#3e4451')
  -- vim.cmd('autocmd ColorScheme * highlight TelescopePreviewBorder  guifg=#525865')
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
      desc = '[Telescope] Abre o telescope git_status, para arquivos alterados no git',
      '<leader>F',
      function()
        telescope_builtin().git_status()
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
        telescope_builtin().buffers({ sort_mru = true })
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

return {
  lazyPluginSpec = {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = keys(),
    config = function()
      setup()
      -- Setting this here instead of the project_nvim plugin spec because
      -- I don't want to load telescope when loading project_nvim, since
      -- I want to lazy load telescope.
      -- require('telescope').load_extension('projects')
      require('telescope').load_extension('ui-select')
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function()
          require('telescope').load_extension('fzf')
        end,
      },
      {
        -- If not working, read this https://github.com/nvim-telescope/telescope-smart-history.nvim/issues/4
        'nvim-telescope/telescope-smart-history.nvim',
        config = function()
          require('telescope').load_extension('smart_history')
        end,
        -- Had to install sqlite-devel package, too
        dependencies = 'kkharji/sqlite.lua',
      },
      {
        'debugloop/telescope-undo.nvim',
        config = function()
          require('telescope').load_extension('undo')
        end,
      },
      {
        'molecule-man/telescope-menufacture',
        config = function()
          require('telescope').load_extension('menufacture')
        end,
      },
    },
  },
}
