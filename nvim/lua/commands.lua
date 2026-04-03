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

-- %s/:\?\(['"a-zA-Z_0-9]*\) *=> *\(:\?'.*'\|:\?".*"\|:\?[a-zA-Z_0-9!?]*\)/\1: \2
-- Regex I came up with when I was starting with vim.
-- Transforms the rocket hash to symbol syntax. Works in ruby and elixir. Hopefully.
-- Maybe I could add this to filetype files or something, but anyways.
vim.api.nvim_create_user_command('RocketHash', [[%s/:\?\(['"a-zA-Z_0-9]*\) *=> *\(:\?'.*'\|:\?".*"\|:\?[a-zA-Z_0-9!?]*\)/\1: \2]], {})

-- https://til.hashrocket.com/posts/ha0ci0pvkj-format-json-in-vim-with-jq
vim.api.nvim_create_user_command('JqDocument', [[%!jq]], {})
