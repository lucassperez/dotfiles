--[[
  Session <command> <filename>

  - command:  `new` or `create_or_update` (defaults to `create_or_update`)
  - filename: any (defaults to `vim-session.vim`)

  The expected arguments passed to this function are of the form

    Session <command> <filename>

  Where command is one of `new` or `create_or_update`.
  If the first argument, <command>, is neither `new` nor `create_or_update`,
  I'm assuming we are doing a 'create_or_update` and the first argument
  already is the filename.
  If multiple arguments are passed, the first one defines the command and the
  others are all considered the filename, and are joined with a dash (-).
  The filename is also prepended with `vim-session` and appended with `.vim`.
  So calling this command like this:

    Session new example name

  Will execute `mksession vim-session-example-name.vim'.
  And calling it like this:

    Session this is already the filename

  Will execute 'mksession vim-session-this-is-already-the-filename.vim'.
  If the filename ends up being an empty string,
  it will default to 'vim-session.vim'.
  You can also call this command with a bang. In this case, it will execute
  a 'create_or_update', which just translates to vim's 'mksession!'.
  Calling this without any arguments at all, simply 'Session', will end up
  executing 'mksession! vim-session.vim'. This is because the command will
  default to `create_or_update` (which translates to mksession!) and the
  filename will default to 'vim-session.vim'.
]]
vim.api.nvim_create_user_command('Session', function(opts)
  local args = opts.fargs

  local command = args[1]
  local filename_starts_at = 2
  if command ~= 'new' and command ~= 'create_or_update' then
    command = 'create_or_update'
    filename_starts_at = 1
  end
  if opts.bang then command = 'create_or_update' end

  local filename = ''
  for i = filename_starts_at, #args do
    filename = filename .. '-' .. args[i]
  end
  filename = filename:gsub('^vim%-session%-', ''):gsub('%.vim$', '')
  -- Consequence: If filename is empty, it will default to vim-session.vim
  filename = 'vim-session' .. filename .. '.vim'

  if command == 'new' then
    vim.cmd('mksession ' .. filename)
    print('Created session named `' .. filename .. '`')
  elseif command == 'create_or_update' then
    vim.cmd('mksession! ' .. filename)
    print('Created or updated session named `' .. filename .. '`')
  end
end, {
  desc = 'Cria uma sessão. Se não passar nenhum argumento, o nome padrão é vim-session.vim.',
  -- :h command-attributes
  nargs = '*', -- 0 or more arguments allowed
  -- complete = function(arg_lead, cmd_line, cursor_pos)
  --   return {
  --     'new',
  --     'create_or_update',
  --   }
  -- end,
  complete = 'file',
  bang = true,
})

vim.cmd([[
" Old way to get groups of word under cursor.
" With Inspect and vim.inspect_pos this is not needed anymore,
" but I wanted to leave it here because it is pretty nice. (:
" And it works with plain vim, too!
" function! SynGroup()
"     let l:s = synID(line('.'), col('.'), 1)
"     echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
" endfun
" nnoremap <F1> :call SynGroup()<CR>

" https://stackoverflow.com/questions/3878692/how-to-create-an-alias-for-a-command-in-vim
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
call SetupCommandAlias('W',   'w')
call SetupCommandAlias('Wq',  'wq')
call SetupCommandAlias('Wqa', 'wqa')
call SetupCommandAlias('Wa',  'wa')
call SetupCommandAlias('Q',   'q')
call SetupCommandAlias('Qa',  'qa')
call SetupCommandAlias('qA',  'qa')
]])
-- This can kinda be done in lua with vim.api.nvim_create_user_command
-- vim.api.nvim_create_user_command('W',   'w', {})
-- The difference is that with vimscript, when I execute :Wa, it shows :wa, and
-- the lua version only allows commands that start with uppercase letter, so I
-- can't setup the 'qA' command, for example,
-- which has questionable usefulness, but still...
