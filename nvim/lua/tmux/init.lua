require('tmux.keymappings')
require('tmux.user_commands')
require('tmux.navigator')

return {
  runner = require('tmux.runner'),
  test = require('tmux.modules.test'),
  linter = require('tmux.modules.linter'),
  from_git_generic = require('tmux.modules.from-git-generic'),
  execute_file = require('tmux.modules.execute-file'),
}
