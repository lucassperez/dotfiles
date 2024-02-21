return function()
  local recent_projects = require('project_nvim').get_recent_projects()

  require('fzf-lua.providers.ui_select')
      .ui_select(
        recent_projects,
        { prompt = 'Projetos recentes > ' },
        function(project_dir)
          if project_dir == nil then return end

          require('fzf-lua').files({ cwd = project_dir })
        end
      )
end
