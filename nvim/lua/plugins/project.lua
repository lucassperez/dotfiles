require('project_nvim').setup({
  -- Manual mode doesn't automatically change your root directory, so you have
  -- the option to manually do so using `:ProjectRoot` command.
  manual_mode = false,

  -- Methods of detecting the root directory. **'lsp'** uses the native neovim
  -- lsp, while **'pattern'** uses vim-rooter like glob pattern matching. Here
  -- order matters: if one is not detected, the other is used as fallback. You
  -- can also delete or rearangne the detection methods.
  detection_methods = { 'lsp', 'pattern' },

  -- All the patterns used to detect root dir, when **'pattern'** is in
  -- detection_methods
  patterns = { '.git', 'go.mod', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },

  -- Table of lsp clients to ignore by name
  -- eg: { 'efm', ... }
  ignore_lsp = {},

  -- Don't calculate root dir on specific directories
  -- Ex: { '~/.cargo/*', ... }
  exclude_dirs = {},

  -- Show hidden files in telescope
  show_hidden = false,

  -- When set to false, you will get a message when project.nvim changes your
  -- directory.
  silent_chdir = false,

  -- What scope to change the directory, valid options are
  -- * global (default)
  -- * tab
  -- * win
  scope_chdir = 'global',

  -- Path where project.nvim will store the project history for use in
  -- telescope
  datapath = vim.fn.stdpath('data'),
})

vim.api.nvim_create_user_command('Project', function(opts)
  local command = opts.fargs[1]
  if command == nil then command = 'picker' end

  if command == 'root_dir' then
    vim.cmd.ProjectRoot()
  elseif command == 'picker' then
    local recent_projects = require('project_nvim').get_recent_projects()

    if #recent_projects == 0 then
      vim.notify('Nenhum projeto recente', vim.log.levels.INFO)
      return
    end

    local ok, fuzzy_finder = pcall(require, 'plugins.FUZZY_FINDER')
    if ok and fuzzy_finder ~= nil then
      fuzzy_finder.project_picker()
    else
      vim.notify('ERRO: '.. vim.inspect(fuzzy_finder), vim.log.levels.ERROR)
    end
  end
end, {
  desc = '',
  nargs = '*',
  complete = function()
    return {
      'root_dir',
      'picker',
    }
  end,
})
