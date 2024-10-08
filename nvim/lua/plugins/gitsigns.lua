local gitsigns = require('gitsigns')

gitsigns.setup({
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local function buf_map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    local should_centralize = false
    local function map_hunk_navigation(keymap, direction, show_preview, description)
      buf_map('n', keymap, function()
        gitsigns.nav_hunk(direction, { wrap = false, preview = show_preview }, should_centralize and function()
          vim.fn.feedkeys('zz', 'n')
        end or nil, { desc = '[Gitsigns] ' .. description })
      end)
    end

    map_hunk_navigation('[c', 'prev', false, 'Vai para o hunk anterior do git')
    map_hunk_navigation(']c', 'next', false, 'Vai para o próximo hunk do git')
    map_hunk_navigation('[C', 'prev', true, 'Vai para o hunk anterior do git e mostra o diff')
    map_hunk_navigation(']C', 'next', true, 'Vai para o próximo hunk do git e mostra o diff')


    buf_map('n', ',ch', function()
      gitsigns.preview_hunk()
    end, { desc = '[Gitsigns] Mostra o diff do hunk do git' })
    buf_map('n', ',cr', function()
      gitsigns.reset_hunk()
    end, { desc = '[Gitsigns] Resta o hunk do git (git reset)' })
    buf_map('n', ',cw', function()
      print('Gitsigns word diff toggled: ' .. tostring(gitsigns.toggle_word_diff()))
    end, { desc = '[Gitsigns] Liga/desliga o Gitsigns word diff' })

    -- Text objects
    buf_map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true })
    buf_map({ 'o', 'x' }, 'ah', ':<C-U>Gitsigns select_hunk<CR>', { silent = true })
    buf_map({ 'o', 'x' }, 'ic', ':<C-U>Gitsigns select_hunk<CR>', { silent = true })
    buf_map({ 'o', 'x' }, 'ac', ':<C-U>Gitsigns select_hunk<CR>', { silent = true })
  end,
})

vim.cmd([[
hi GitSignsAdd            guifg=#00af00 gui=BOLD           ctermfg=34  cterm=BOLD
hi GitSignsChange         guifg=#c39f00 gui=ITALIC,BOLD    ctermfg=3   cterm=ITALIC,BOLD
hi GitSignsDelete         guifg=#ec2929 gui=UNDERLINE,BOLD ctermfg=red cterm=UNDERLINE,BOLD
hi GitSignsChangeDelete   guifg=#d75f00 gui=UNDERCURL,BOLD ctermfg=166 cterm=UNDERCURL,BOLD
" I've been crazy searching on wtf is top delete, so
" I set a weird color for it and started deleting lines.
" Very shortly I learned that apparently, it is when
" you delete the first line of the file.
" And you know what? I think I'm gonna keep it (:
hi GitSignsTopDelete      guifg=#ff5fff gui=UNDERLINE,BOLD ctermfg=207 cterm=UNDERLINE,BOLD

hi GitSignsUntracked guifg=#44aa44
hi link GitSignsUntrackedNr GitSignsUntracked

hi link GitSignsAddNr          GitSignsAdd
hi link GitSignsChangeNr       GitSignsChange
hi link GitSignsDeleteNr       GitSignsDelete
hi link GitSignsChangeDeleteNr GitSignsChangeDelete
hi link GitSignsTopDeleteNr    GitSignsTopDelete
hi link GitSignsUntrackedNr GitSignsAddNr

hi GitSignsStaged guifg=#85bdda gui=BOLD,UNDERLINE
hi! link GitSignsStagedNr GitSignsStaged
hi! link GitSignsStagedAdd GitSignsStaged
hi! link GitSignsStagedChange GitSignsStaged
hi! link GitSignsStagedDelete GitSignsStaged
hi! link GitSignsStagedChangeDelete GitSignsStaged
hi! link GitSignsStagedAddNr GitSignsStaged
hi! link GitSignsStagedChangeNr GitSignsStaged
hi! link GitSignsStagedDeleteNr GitSignsStaged
hi! link GitSignsStagedChangeDeleteNr GitSignsStaged

hi GitSignsCurrentLineBlame guifg=#cccccc gui=ITALIC ctermfg=252 cterm=ITALIC
]])
