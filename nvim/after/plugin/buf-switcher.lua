if true then
  return
end

vim.keymap.set('n', '<leader>b', ':BufSwitcher<CR>', {
  remap = false,
  desc = 'Mostra uma lista com os buffers abertos, e ao digitar o id de um buffer, muda automaticamente',
})

vim.api.nvim_create_user_command('BufSwitcher', function()
  BufSwitcher()
end, {})

local backspace = vim.keycode('<BS>')
local enter = vim.keycode('<CR>')
local quit_chars = {
  'q',
  'Q',
  vim.keycode('<ESC>'),
  vim.keycode('<C-q>'),
}

local function msg(arg, hist)
  vim.api.nvim_echo(arg, hist or false, {})
end

local function clear()
  vim.api.nvim_echo({ { '', '' } }, false, { id = 'ui2-clear-cmdline' })
end

function BufSwitcher()
  local lines = {}

  for line in vim.fn.execute('ls'):gmatch('[^\n]+') do
    -- local bufnr, state, name, line_n = line:match('^%s*([0-9]+)%s(..)%s*"(.*)"%s*(line [0-9]*)$')
    local bufnr = line:match('^%s*([0-9]+)%s(..)%s*"(.*)"%s*(line [0-9]*)$')

    if bufnr then
      lines[#lines + 1] = { bufnr = bufnr, line = line }
    end
  end

  local function filtered_by_input(input)
    local result = {}

    for _, entry in ipairs(lines) do
      if (entry.bufnr):match('^' .. input) then
        result[#result + 1] = entry
      end
    end
    return result
  end

  local function actually_switch(bufnr)
    clear()
    msg({ { 'Mudando para o buffer ' .. bufnr, 'String' } }, true)
    vim.api.nvim_set_current_buf(tonumber(bufnr))
  end

  local input = {}

  local input_str_so_far
  local candidates
  local chunks

  local old_more = vim.o.more
  vim.o.more = false
  local old_cmdheight = vim.o.cmdheight

  local previous_char = nil

  pcall(function()
    while true do
      input_str_so_far = table.concat(input)
      candidates = filtered_by_input(input_str_so_far)

      chunks = {}

      for _, entry in ipairs(candidates) do
        chunks[#chunks + 1] = { entry.line, 'Normal' }
        chunks[#chunks + 1] = { '\n', 'Normal' }
      end
      chunks[#chunks + 1] = { ':b ' .. input_str_so_far, 'String' }
      -- Put a fake cursor at the end so it looks like
      -- that is where we are going to type next
      chunks[#chunks + 1] = { ' ', 'Cursor' }

      --[[
      I think that this echo command was triggering some sort of press enter
      message, which was consuming char if it was enter?
      So we are increasing the cmdheight before printing to accodomate
      the amount of lines we are going to need before printing.
      Basically we need #candidates + 1 for the prompt.
      ]]
      vim.o.cmdheight = #candidates + 1
      -- TODO make g< work with the printed message
      msg(chunks)

      local ok, char = pcall(vim.fn.getcharstr)

      if not ok then
        msg({ { '', '' } })
        return
      end

      if previous_char == 'g' and char == '<' then
        vim.fn.feedkeys('g<', 'n')
        return
      end

      previous_char = char

      if char == enter then
        if input_str_so_far ~= '' then
          actually_switch(input_str_so_far)
        end
        return
      elseif char == backspace then
        table.remove(input)
      elseif char:match('[0-9]') then
        table.insert(input, char)
        local new_str = table.concat(input)
        local new_candidates = filtered_by_input(new_str)

        if #new_candidates == 1 then
          actually_switch(new_candidates[1].bufnr)
          return
        end

        if #new_candidates == 0 then
          msg({ { '-- Vazio --', '' } })
        end

      elseif vim.tbl_contains(quit_chars, char) then
        clear()
        return
      end
    end
  end)

  vim.o.more = old_more
  vim.o.cmdheight = old_cmdheight
end
