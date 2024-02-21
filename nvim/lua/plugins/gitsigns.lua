local gitsigns = require('gitsigns')

gitsigns.setup({
  signs = {
    add = { hl = 'GitSignsAdd', numhl = 'GitSignsAddNr', linehl = '' },
    change = { hl = 'GitSignsChange', numhl = 'GitSignsChangeNr', linehl = '' },
    delete = { hl = 'GitSignsDelete', numhl = 'GitSignsDeleteNr', linehl = '' },
    topdelete = { hl = 'GitSignsTopDelete', numhl = 'GitSignsTopDeleteNr', linehl = '' },
    changedelete = {
      hl = 'GitSignsChangeDelete',
      numhl = 'GitSignsChangeDeleteNr',
      linehl = '',
    },
    untracked = {
      hl = 'GitSignsAdd',
      numhl = 'GitSignsAddNr',
      linehl = '',
    },
  },
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
  yadm = {
    enable = false,
  },
  on_attach = function(bufnr)
    local function buf_map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    local function map_hunk_navigation(keymap, hunk_function, show_preview, description)
      buf_map('n', keymap, function()
        hunk_function({ wrap = false, preview = show_preview })
        -- if #gitsigns.get_hunks() > 0 then
        --   vim.schedule(function()
        --     vim.api.nvim_feedkeys('zz', 'n', false)
        --   end)
        -- end
      end, { desc = description })
    end

    map_hunk_navigation('[c', gitsigns.prev_hunk, false, 'Vai para o hunk anterior do git')
    map_hunk_navigation(']c', gitsigns.next_hunk, false, 'Vai para o próximo hunk do git')
    map_hunk_navigation('[C', gitsigns.prev_hunk, true, 'Vai para o hunk anterior do git e mostra o diff')
    map_hunk_navigation(']C', gitsigns.next_hunk, true, 'Vai para o próximo hunk do git e mostra o diff')

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
" I set a werid color for it and started deleting lines.
" Very shortly I learned that apparently, it is when
" you delete the first line of the file.
" And you know what? I think I'm gonna keep it (:
hi GitSignsTopDelete      guifg=#ff5fff gui=UNDERLINE,BOLD ctermfg=207 cterm=UNDERLINE,BOLD

hi link GitSignsAddNr          GitSignsAdd
hi link GitSignsChangeNr       GitSignsChange
hi link GitSignsDeleteNr       GitSignsDelete
hi link GitSignsChangeDeleteNr GitSignsChangeDelete
hi link GitSignsTopDeleteNr    GitSignsTopDelete

hi GitSignsCurrentLineBlame guifg=#cccccc gui=ITALIC ctermfg=252 cterm=ITALIC
]])
