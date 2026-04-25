return {
  create = function(loaded)
    vim.api.nvim_create_user_command('PackList', function()
      local packs = vim.pack.get()

      for i, pack in ipairs(packs) do
        local format_str = " %s %03s %-30s [%s] %s/%s"

        if pack.spec.version then
          format_str = format_str .. ' %s'
        end

        local active = pack.active
        local is_loaded = loaded[pack.spec.name]

        local active_loaded_str
        if active and is_loaded then
          active_loaded_str = 'LA'
        elseif active then
          active_loaded_str = ' A'
        elseif is_loaded then
          -- I don't think this is possible, but anyways
          active_loaded_str = 'L '
        else
          active_loaded_str = '  '
        end

        print(string.format(
          format_str,
          active_loaded_str,
          i,
          pack.spec.name,
          string.sub(pack.rev, 1, 6),
          pack.branches and pack.branches[1],
          pack.branches and pack.branches[2],
          pack.spec.version
        ))
      end
    end, {})
  end
}
