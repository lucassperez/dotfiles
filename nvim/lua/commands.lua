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

vim.cmd([[
" https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/folds.vim
function! SuperFoldToggle()
    " Force the fold on the current line to immediately open or close.  Unlike za
    " and zo it only takes one application to open any fold.  Unlike zO it does
    " not open recursively, it only opens the current fold.
    if foldclosed('.') == -1
        silent! foldclose
    else
        while foldclosed('.') != -1
            silent! foldopen
        endwhile
    endif
endfunction
nmap <silent> zf :call SuperFoldToggle()<CR>
]])

local cd_command_string = ":execute 'cd' getcwd()"
vim.api.nvim_create_user_command('CD', cd_command_string, {})
vim.api.nvim_create_user_command('Cd', cd_command_string, {})
