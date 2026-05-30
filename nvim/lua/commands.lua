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

local cd_command_string = ":execute 'cd' getcwd()"
vim.api.nvim_create_user_command('CD', cd_command_string, {})
vim.api.nvim_create_user_command('Cd', cd_command_string, {})

vim.api.nvim_create_user_command('RocketHash', function(opts)
  if #opts.fargs > 0 and opts.fargs[1] ~= 'toggle' then
    vim.notify('Commando inválido: ' .. opts.fargs[1], vim.log.levels.ERROR)
    return
  end

  local search_symbol  = [[\('[^']*'\|"[^"]*"\|[a-zA-Z0-9_]\+\):\s*]]
  local search_rocket  = [[:\('[^']*'\|"[^"]*"\|[a-zA-Z0-9_]\+\)\s*=>\s*]]
  local replace_symbol = [[\1: ]]
  local replace_rocket = [[:\1 => ]]

  local range
  if opts.range <= 0 then
    range = '%'
  else
    range = string.format('%s,%s', opts.line1, opts.line2)
  end

  if #opts.fargs <= 0 then
    if opts.bang then
      vim.cmd(string.format('%ss/%s/%s/g', range, search_symbol, replace_rocket))
    else
      vim.cmd(string.format('%ss/%s/%s/g', range, search_rocket, replace_symbol))
    end

    vim.cmd('noh')
    return
  end

  -- Toggle logic
  local l1 = opts.range > 0 and opts.line1 - 1 or 0
  local l2 = opts.range > 0 and opts.line2 or -1
  local text = table.concat(vim.api.nvim_buf_get_lines(0, l1, l2, false), '\n')

  local search, replace
  if opts.bang then
    if text:find("['\"%a_].-:%s") then
      search, replace = search_symbol, replace_rocket
    else
      search, replace = search_rocket, replace_symbol
    end
  else
    if text:find(":['\"%a_].-=>") then
      search, replace = search_rocket, replace_symbol
    else
      search, replace = search_symbol, replace_rocket
    end
  end

  vim.cmd(string.format('%ss/%s/%s/g', range, search, replace))
  vim.cmd('noh')
end, {
  range = true,
  bang = true,
  nargs = '?',
  complete = function() return { 'toggle' } end,
})

-- https://til.hashrocket.com/posts/ha0ci0pvkj-format-json-in-vim-with-jq
vim.api.nvim_create_user_command('Jq', function(opts)
  -- We could use vim.system to intercept stdout and stderr separetely, and then
  -- do some magic with nvim_buf_set_lines to avoid writing the jq error message.
  -- But this one is so simple, and the other one is so complex, that I am good.
  -- If jq errors out, we can just undo with `u`.
  if opts.range <= 0 then
    vim.cmd('%!jq')
  else
    vim.cmd(string.format('%s,%s!jq', opts.line1, opts.line2))
  end
end, { range = true })

vim.api.nvim_create_user_command('Undotree', function()
  vim.api.nvim_del_user_command('Undotree')
  vim.cmd([[
  packadd nvim.undotree
  Undotree
  ]])
end, {})
vim.keymap.set('n', '<leader>u', ':Undotree<CR>')
