vim.cmd([[
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
nnoremap <F1> :call SynGroup()<CR>

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
" This can kinda be done in lua with vim.api.nvim_create_user_command
" vim.api.nvim_create_user_command('W',   'w', {})
" The difference is that with vimscript, when I execute :Wa, it shows :wa, and
" the lua version only allows commands that start with uppercase letter, so I
" can setup the 'qA' command, for example,
" which has questionable usefulness, but still...
]])
