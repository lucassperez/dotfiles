local helpers = require('lsp.helpers')

local complete = require('utils.user_command_complete')

return {
  create = function(installed_servers)
    installed_servers = installed_servers or helpers.get_installed_servers()

    vim.api.nvim_create_user_command('LspStart', function(opts)
      if #opts.fargs > 0 then
        for _, server_name in pairs(opts.fargs) do
          helpers.setup_server(server_name)
          vim.notify('LSP started for ' .. table.concat(opts.fargs), vim.log.levels.INFO)
        end
        return
      end

      local servers = helpers.get_installed_servers()

      for _, server in ipairs(servers) do
        helpers.setup_server(server)
      end

      vim.notify('LSP started for installed servers', vim.log.levels.INFO)
    end, {
      nargs = '*',
      complete = complete.simple(installed_servers),
    })

    vim.api.nvim_create_user_command('LspStop', function(opts)
      local wanted = {}
      for _, name in ipairs(opts.fargs) do
        wanted[name] = true
      end

      local clients = {}
      for _, client in ipairs(vim.lsp.get_clients()) do
        if wanted[client.name] then
          clients[#clients+1] = client
        end
      end

      if #clients == 0 then
        vim.notify('No clients to stop', vim.log.levels.INFO)
        return
      end

      for _, client in ipairs(clients) do
        client:stop()
        vim.notify('Client stopped: ' .. client.name, vim.log.levels.INFO)
      end
    end, {
      nargs = '*',
      complete = complete.simple(installed_servers),
    })

    vim.api.nvim_create_user_command('LspRestart', function(opts)
      local clients = vim.lsp.get_clients(opts.fargs)

      for _, client in ipairs(clients) do
        client:stop()
      end

      for _, client in ipairs(clients) do
        vim.defer_fn(function()
          helpers.setup_server(client.name)
        end, 500)
      end

      vim.notify('LSP restarted', vim.log.levels.INFO)
    end, {
      nargs = '*',
      complete = complete.simple(installed_servers),
    })

    vim.api.nvim_create_user_command('LspCheckhealth', function()
      vim.cmd.checkhealth('lsp')
    end, { nargs = 0 })
  end
}

