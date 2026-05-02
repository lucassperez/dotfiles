return {
  new = function(state, opts)
    -- These two values, available and padding_w, were used so much that
    -- I decided to "globaly initialize" them here.
    local available = vim.o.columns - state.tab_len
    local padding_w = 2 -- padding width, since I know padding is going to be
                        -- two spaces around the buffer name, hardcoded.

    local function truncate_string_left(str, max)
      if vim.fn.strdisplaywidth(str) <= max then
        return str
      end

      local width = opts.ellipsis_width
      local result = ''

      for i = vim.fn.strchars(str), 1, -1 do
        local char = vim.fn.strcharpart(str, i - 1, 1)
        local char_width = vim.fn.strdisplaywidth(char)

        if width + char_width > max then
          break
        end

        result = char .. result
        width = width + char_width
      end

      return opts.ellipsis .. result
    end

    local function truncate_list(list, path_with_suffix, suffix)
      -- Very confusing, but `path_with_suffix` includes suffix, but
      -- `list[#list]` does not.
      -- Remember that list[#list] is the filename (without suffix) generated
      -- from buf_tree and buf_tree_flattened. The last item is the filename,
      -- and the first is the parent directory, if filename alone is not enough
      -- to uniquely identify the buffer.
      -- Suffix is, for example, [+] for modified.

      if #list == 1 then
        -- This scenario is when the buffer's file name alone is unique,
        -- but it is too big. So we truncate the string from the left.
        local new_path = truncate_string_left(path_with_suffix, opts.max_buffer_name_size)
        return new_path, vim.fn.strdisplaywidth(new_path)
      end

      if #list == 2 then
        -- This scenario is when the buffer's file name alone is not enough to
        -- uniquely identify the buffer.

        -- Remember that list[#list] does not have the suffix, since it is
        -- just the filename from buf_tree and buf_tree_flattened.
        -- So we have to add it, and thus new_filename contains the suffix.
        local new_filename = truncate_string_left(list[#list] .. suffix, opts.max_buffer_name_size)

        -- In this case, list only has 2 elements, remember.
        -- We are basically truncating it like this:
        -- { directory, verybigfilenameoverthelimit.txt } -> directory/...verthelimit.txt
        local new_path = table.concat({list[1], new_filename}, opts.directory_separator)
        -- The final size depends on opts.max_buffer_name_size, of course.

        local new_width = vim.fn.strdisplaywidth(new_path)
        if new_width <= opts.max_buffer_name_size then
          return new_path, new_width
        end

        local truncated_old_path = truncate_string_left(path_with_suffix, opts.max_buffer_name_size)
        return truncated_old_path, vim.fn.strdisplaywidth(truncated_old_path)
      end

      -- From here on, it means the path has more than one directory.
      -- The first item in `list` is the outermost directory,
      -- and the last is the filename.
      -- We'll try truncating the middle directories first.
      local suffix_size = vim.fn.strdisplaywidth(suffix)
      local i = #list - 1
      local path_after_trunc
      local path_after_trunc_width
      local list_copy = { unpack(list) }

      while true do
        list_copy[i] = vim.fn.strcharpart(list_copy[i], 0, 1)

        path_after_trunc = table.concat(list_copy, opts.directory_separator)
        path_after_trunc_width = vim.fn.strdisplaywidth(path_after_trunc)

        if path_after_trunc_width + suffix_size <= opts.max_buffer_name_size then
          break
        end

        i = i - 1
        if i <= 0 then
          break
        end
      end

      return path_after_trunc .. suffix, path_after_trunc_width + suffix_size
    end

    local function path_from_flattened_buf_tree_list(list, buf)
      local path = table.concat(list, opts.directory_separator)

      local suffix = ''

      if buf.readonly then suffix = suffix .. opts.readonly end
      if buf.modified then suffix = suffix .. opts.modified end
      if buf.non_modifiable then suffix = suffix .. opts.non_modifiable end

      path = path .. suffix

      local width = vim.fn.strdisplaywidth(path)

      if width > opts.max_buffer_name_size then
        path, width = truncate_list(list, path, suffix)
      end

      return path, width
    end

    local function build_every_path_entry()
      local entries = {}

      for i, buf in ipairs(state.buffers) do
        local list = state.buf_tree_flattened[buf.bufnr]
        local path, width = path_from_flattened_buf_tree_list(list, buf)

        entries[i] = {
          path = path,
          hl = opts.visibility_to_hl[buf.visibility],
          width = width,
          bufnr = buf.bufnr,
        }
      end

      return entries
    end

    local function find_visible_window(entries)
      local start_i = state.current_i
      local end_i = state.current_i
      local used = entries[state.current_i].width + padding_w
      local truncate_index

      local last_expand_was_left = false

      while true do
        if last_expand_was_left then
          -- try right
          if start_i > 1 then
            used = used + entries[start_i - 1].width + padding_w
            start_i = start_i - 1
            if used > available then
              truncate_index = start_i
            end
            if used >= available then
              break
            end
          end

          last_expand_was_left = false
        else
          -- try left
          if end_i < #entries then
            used = used + entries[end_i + 1].width + padding_w
            end_i = end_i + 1
            if used > available then
              truncate_index = end_i
            end
            if used >= available then
              break
            end
          end

          last_expand_was_left = true
        end

        if start_i <= 1 and end_i >= #entries then
          break
        end
      end

      if truncate_index == state.current_i then
        if state.current_i == 1 then
          truncate_index = 2
        else
          truncate_index = truncate_index - 1
        end
      end

      return start_i, end_i, truncate_index
    end

    local function render_window(entries, start_i, end_i, truncate_index)
      local total_width = 0

      local visible_entries_copy = {}
      for i = start_i, end_i do
        visible_entries_copy[#visible_entries_copy + 1] = {
          path = entries[i].path,
          width = entries[i].width,
          hl = entries[i].hl,
          bufnr = entries[i].bufnr,
        }

        total_width = total_width + entries[i].width + padding_w
      end


      if truncate_index then
        local overflow = total_width - available

        local middle = start_i + math.floor((end_i - start_i)/2)
        if state.current_i <= middle then
          truncate_index = #visible_entries_copy
        else
          truncate_index = 1
        end

        if truncate_index == state.current_i then
          if truncate_index == end_i then
            truncate_index = start_i
          else
            truncate_index = #visible_entries_copy
          end
        end

        local entry = visible_entries_copy[truncate_index]

        local target_width = entry.width - overflow

        if target_width < 1 then
          entry.very_small_width = target_width + padding_w
          target_width = 1
        end

        entry.path = truncate_string_left(entry.path, target_width)
        entry.width = vim.fn.strdisplaywidth(entry.path)
      end

      -- Finally renders
      local tabline = {}
      for i, entry in ipairs(visible_entries_copy) do
        -- Padding around entry.path is hardcoded, which I hate.
        -- ):

        local format_str
        -- Very small is when padding + ellipsis would be too big.
        -- So we remove the padding depending on "how small" it is
        if entry.very_small_width == 1 then
          format_str = '%%%s@v:lua.MyTabline.click_handler@%s%s%%X'
        elseif entry.very_small_width == 2 then
          format_str = '%%%s@v:lua.MyTabline.click_handler@%s%s %%X'
        else
          format_str = '%%%s@v:lua.MyTabline.click_handler@%s %s %%X'
        end

        tabline[i] = string.format(
          format_str,
          entry.bufnr,
          entry.hl,
          entry.path
        )
      end

      return table.concat(tabline)
    end

    return {
      buffers_paths = function()
        if state.current_i < 1 or state.current_i > #state.buffers then
          state.current_i = 1
        end

        local entries = build_every_path_entry()
        local start_i, end_i, truncate_index = find_visible_window(entries)

        return render_window(entries, start_i, end_i, truncate_index)
      end
    }
  end
}
