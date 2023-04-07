local function keys(module, telescope_git_or_find_files, menufacture)
  local t = {
    { 'n', '<C-p>', function() telescope_git_or_find_files() end, { noremap = true }, },
    { 'n', '<C-f>', function() menufacture.live_grep() end, { noremap = true }, },
    { 'n', '<leader>P', function() module.buffers() end, { noremap = true }, },
    { 'n', '<leader>h', function() module.oldfiles() end, { noremap = true },},
    { 'n', '<leader>zv', function() menufacture.find_files({ cwd = vim.fn.stdpath('config') }) end, { noremap = true }, },
  }

  if module == nil then
    local lazy_load_triggers = {}
    for _, v in pairs(t) do table.insert(lazy_load_triggers, { mode = v[1], v[2] }) end
    return lazy_load_triggers
  end

  return t
end

local function setup()
  local telescope = require('telescope')
  local telescope_builtin = require('telescope.builtin')
  local menufacture = require('telescope').extensions.menufacture

  function TelescopeGitOrFindFiles(opts)
    local code = os.execute('git rev-parse --git-dir 2>/dev/null 1>&2')
    if code == 0 then
      opts = opts or {}
      opts.show_untracked = true
      menufacture.git_files(opts)
    else
      menufacture.find_files(opts)
    end
  end

  for _, mapping in pairs(keys(telescope_builtin, TelescopeGitOrFindFiles, menufacture)) do
    vim.keymap.set(unpack(mapping))
  end

  -- local actions = require('telescope.actions')

  telescope.setup({
    pickers = {
      lsp_references = { show_line = false },
      -- diagnostics = { path_display = 'hidden' },
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
          -- ['<C-p>'] = actions.move_selection_previous + actions.move_selection_previous + actions.move_selection_previous,
          -- ['<C-n>'] = actions.move_selection_next + actions.move_selection_next + actions.move_selection_next,
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
