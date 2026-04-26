return {
  create = function(pack_wrap_loaded, resolved)
    vim.api.nvim_create_user_command('PackList', function(opts)
      local packs
      if #opts.fargs > 0 then
        packs = vim.pack.get(opts.fargs)
      else
        packs = vim.pack.get()
      end

      print(' AL  nº  name                             rev    branches   (version)')
      print('----------------------------------------------------------------------')
      for i, pack in ipairs(packs) do
        local format_str = " %s %03s  %-30s [%s] %-10s"

        if pack.spec.version then
          format_str = format_str .. '\t(%s)'
        end

        local active = pack.active
        local is_loaded = pack_wrap_loaded[pack.spec.name]

        local active_loaded_str
        if active and is_loaded then
          active_loaded_str = ' L'
        elseif active then
          active_loaded_str = 'A '
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
          pack.spec.version
        ))
      end
    end, { nargs = '*', complete = function ()
      local k = {}
      for _, value in pairs(resolved) do
        table.insert(k, value.name)
      end
      return k
    end})
  end
}
