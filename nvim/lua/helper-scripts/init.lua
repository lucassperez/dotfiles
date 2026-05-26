return {
  require_scripts = function(require_function)
    require_function = require_function or require
    require_function('helper-scripts.togglebetweentestandfile')
    require_function('helper-scripts.write-debugger-breakpoint')
  end,
}
