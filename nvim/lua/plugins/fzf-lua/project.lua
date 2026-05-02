-- I don't even have project_nvim anymore, and I don't think I have
-- ever used it when I had. The reason I am keeping this here is
-- just so I can see an fzf-lua.providers.ui_select example.

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
