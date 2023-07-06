return {
  require_scripts = function(require_function)
    require_function = require_function or require

    require_function('helper-scripts.vtr.test')
    require_function('helper-scripts.vtr.linter')
    require_function('helper-scripts.vtr.from-git-generic')
    require_function('helper-scripts.vtr.execute-script')
    require_function('helper-scripts.vtr.send-line-to-tmux')
    require_function('helper-scripts.vtr.compile-file')
    require_function('helper-scripts.togglebetweentestandfile')
    require_function('helper-scripts.write-debugger-breakpoint')
  end
}
