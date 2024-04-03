--[[
  Session <command> <filename>

  - command:  `new` or `create_or_update` or `load` (defaults to `create_or_update` unless a special case*)
  - filename: any (defaults to `vim-session.vim`)
  * If no buffers are opened, then it performs a `load`, >> no matter what <<.

  The expected arguments passed to this function are of the form

    Session <command> <filename>

  Where command is one of `new`, `create_or_update` or `load`.
  If the first argument, <command>, is none of those, I'm assuming we are doing
  a `create_or_update` and the first argument already is the filename.
  The exception is when no buffers are opened. In this case, it executes a
  `load`, where the first argument already is the filename.
  If multiple arguments are passed, the first one defines the command and the
  others are all considered the filename, and are joined with a dash (-).
  The filename is also prepended with `vim-session` and appended with `.vim`.
  So calling this command like this:

    Session new example name

  Will execute `mksession vim-session-example-name.vim` (unless we are in the
  exception case, no files opened).

  And calling it like this:

    Session this is already the filename

  Will execute `mksession vim-session-this-is-already-the-filename.vim` (unless
  the exception case).

  If the filename ends up being an empty string,
  it will default to `vim-session.vim`.

  You can also call this command with a bang. In this case, it will execute
  a `create_or_update`, which just translates to vim's `mksession!` (except the
  exception case).

  The `load` command simply executes a `:source <filename>`, where filename is
  calculated as above.

  Calling this without any arguments at all, simply `Session`, will end up
  executing `mksession! vim-session.vim`. This is because the command will
  default to `create_or_update` (which translates to mksession!) and the
  filename will default to `vim-session.vim`.
  The exception is when there is no file opened. Then it will simply execute
  `source vim-session.vim`. The exception overrides everything, even the bang
  version of Session. Calling `Session!` when no file is opened executes a
  `load`, too.

    !!!
      Calling `Session create_or_update` when no file is opened will execute
      a `load` for a file called `vim-session-create_or_update.vim`!!
    !!!
]]
vim.api.nvim_create_user_command('Session', function(opts)
  local args = opts.fargs

  local command = args[1]

  local filename_starts_at = 2
  local unknown_command = false

  if command ~= 'new' and command ~= 'create_or_update' and command ~= 'load' then
    command = 'create_or_update'
    filename_starts_at = 1
    unknown_command = true
  end

  if opts.bang then command = 'create_or_update' end

  local buffers = vim.fn.getbufinfo()
  local at_least_one_file_open_that_exists_or_has_a_name = false
  for _, b in pairs(buffers) do
    if b.loaded == 1 and b.name ~= '' then
      at_least_one_file_open_that_exists_or_has_a_name = true
      break
    end
  end

  if not at_least_one_file_open_that_exists_or_has_a_name then
    -- If no real buffers opened, then perform a load >> no matter what <<
    command = 'load'
  end

  local filename = ''
  for i = filename_starts_at, #args do
    filename = filename .. '-' .. args[i]
  end
  filename = filename:gsub('^vim%-session%-', ''):gsub('%.vim$', '')
  -- Consequence: If filename is empty, it will default to vim-session.vim
  filename = 'vim-session' .. filename .. '.vim'

  if command == 'new' then
    vim.cmd('mksession ' .. filename)
    vim.notify('Created session named `' .. filename .. '`', vim.log.levels.INFO)
  elseif command == 'load' then
    if vim.fn.filereadable(filename) == 1 then
      vim.cmd('source ' .. filename)
    else
      local _, msg, code = os.rename(filename, filename)
      if code == 2 and msg ~= nil and string.match(msg, 'No such file or directory') then
        vim.notify("Can't source `" .. filename .. '`, file does not exist.', vim.log.levels.ERROR)
      else
        vim.notify("Can't source `" .. filename .. '`, file is not readable.', vim.log.levels.ERROR)
      end
    end
  elseif command == 'create_or_update' then
    vim.cmd('mksession! ' .. filename)
    vim.notify('Created or updated session named `' .. filename .. '`', vim.log.levels.INFO)
  end
end, {
  desc = 'Cria uma sessão. Se não passar nenhum argumento, o nome padrão é vim-session.vim.',
  -- :h command-attributes
  nargs = '*', -- 0 or more arguments allowed
  complete = function(arg_lead, cmd_line, cursor_pos)
    return {
      'new',
      'create_or_update',
      'load',
    }
  end,
  -- complete = 'file',
  bang = true,
})
