return function()
  vim.api.nvim_create_user_command('PackList', function()
    local packs = vim.pack.get()

    for i, pack in ipairs(packs) do
      local format_str = "%03s %-30s %s [%s] %s/%s"

      if pack.spec.version then
        format_str = format_str .. ' %s'
      end

      local loaded
      if pack.active then
        loaded = '[L]'
      else
        loaded = '   '
      end

      print(string.format(
        format_str,
        i,
        pack.spec.name,
        loaded,
        string.sub(pack.rev, 1, 6),
        pack.branches and pack.branches[1],
        pack.branches and pack.branches[2],
        pack.spec.version
      ))
    end
  end, {})

  vim.api.nvim_create_user_command('PackListFloat', function()
    local packs = vim.pack.get()
    local buf = vim.api.nvim_create_buf(false, true)
    local ns = vim.api.nvim_create_namespace('PackListNS')
    local largest_line_len = 0


    for i, pack in ipairs(packs) do
      local loaded
      if pack.active then
        loaded = '[L]'
      else
        loaded = '   '
      end

      local format_str = "%03s %-33s %s [%s] %s/%s"
      local formated_str

      if pack.spec.version then
        format_str = format_str .. '\t\t\t%s'
        formated_str = string.format(
          i,
          format_str,
          pack.spec.name,
          loaded,
          string.sub(pack.rev, 1, 6),
          pack.branches and pack.branches[1],
          pack.branches and pack.branches[2],
          pack.spec.version
        )
      else
        formated_str = string.format(
          format_str,
          pack.spec.name,
          loaded,
          string.sub(pack.rev, 1, 6),
          pack.branches[1],
          pack.branches[2]
        )
      end

      local size = vim.fn.strchars(formated_str)
      if size > largest_line_len then
        largest_line_len = size
      end

      vim.api.nvim_buf_set_lines(buf, i - 1, i - 1, false, { '' })
      vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
        virt_text = { { formated_str, 'Normal' } },
        virt_text_pos = 'overlay',
        virt_text_win_col = 1,
      })
    end

    local width = math.floor((vim.o.columns * 0.8))
    local height = #packs

    local usable_width = vim.o.columns - 1

    local col = math.floor((usable_width - width) / 2)
    local row = math.floor((vim.o.lines - height) / 3)

    local win_config = {
      relative = 'editor',
      row = row,
      col = col,
      width = width,
      height = height,
      style = 'minimal',
      border = 'rounded',
      focusable = true,
      noautocmd = true,
    }

    vim.api.nvim_open_win(buf, false, win_config)
  end, {})
end
