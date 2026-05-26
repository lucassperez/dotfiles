return {
  create = function(state)
    require('tabline.user_commands.buf_delete')(state)
    require('tabline.user_commands.navigation_commands')(state)
  end,
}
