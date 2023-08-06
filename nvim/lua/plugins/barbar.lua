local function setup()
  local function close_buffer_and_return_to_last_buffer()
    -- local buffers = vim.tbl_filter(function(buf) return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') end, vim.api.nvim_list_bufs())
    -- if #buffers == 1 then
    --   vim.cmd.BufferClose()
    --   return
    -- end

    local last_buffer_id = vim.fn.bufnr('#')
    vim.cmd.BufferClose()
    if vim.fn.bufexists(last_buffer_id) == 1 and vim.api.nvim_buf_get_option(last_buffer_id, 'buflisted') then
      vim.cmd('buffer ' .. last_buffer_id)
    end
  end

  vim.api.nvim_create_user_command('BufferCloseAndReturn', close_buffer_and_return_to_last_buffer, {})

  vim.keymap.set(
    'n',
    '<leader>q',
    ':BufferPrevious<CR>',
    { noremap = true, silent = false, desc = 'Mostra o buffer anterior' }
  )
  vim.keymap.set(
    'n',
    '<leader>w',
    ':BufferNext<CR>',
    { noremap = true, silent = false, desc = 'Mostra o próximo buffer' }
  )
  vim.keymap.set(
    'n',
    '<leader>d',
    ':BufferCloseAndReturn<CR>',
    { noremap = true, silent = false, desc = 'Fecha o buffer atual' }
  )

  -- vim.keymap.set('n', '<C-s>', ':BufferPick<CR>', { noremap = true, silent = false, desc = 'Seleciona algum buffer pela tabline (barbar.nvim)', })
  vim.keymap.set(
    'n',
    '<leader>p',
    ':BufferPick<CR>',
    { noremap = true, silent = false, desc = 'Seleciona algum buffer pela tabline (barbar.nvim)' }
  )
  vim.keymap.set(
    'n',
    '<A-e>',
    ':BufferPick<CR>',
    { noremap = true, silent = false, desc = 'Seleciona algum buffer pela tabline (barbar.nvim)' }
  )
  vim.keymap.set(
    'n',
    '<A-q>',
    ':BufferPrevious<CR>',
    { noremap = true, silent = false, desc = 'Mostra o buffer anterior' }
  )
  vim.keymap.set('n', '<A-w>', ':BufferNext<CR>', { noremap = true, silent = false, desc = 'Mostra o próximo buffer' })
  vim.keymap.set('n', '<A-Q>', ':BufferMovePrevious<CR>', {
    noremap = true,
    silent = false,
    desc = 'Move o buffer atual para trás na tabline (barbar.nvim)',
  })
  vim.keymap.set('n', '<A-W>', ':BufferMoveNext<CR>', {
    noremap = true,
    silent = false,
    desc = 'Move o buffer atual para frente na tablin (barbar.nvim)',
  })
  vim.keymap.set(
    'n',
    '<A-D>',
    ':BufferCloseAndReturn<CR>',
    { noremap = true, silent = false, desc = 'Fecha o buffer atual' }
  )

  require('bufferline').setup({
    -- Enable/disable animations
    animation = false,

    -- Enable/disable auto-hiding the tab bar when there is a single buffer
    auto_hide = false,

    -- Enable/disable current/total tabpages indicator (top right corner)
    tabpages = true,

    -- Enable/disable close button
    closable = true,

    -- left-click: go to buffer
    -- middle-click: delete buffer
    clickable = true,

    -- diagnostics = {
    --   [vim.diagnostic.severity.ERROR] = { enabled = true,  icon = 'E' },
    --   [vim.diagnostic.severity.WARN]  = { enabled = false, icon = 'W' },
    --   [vim.diagnostic.severity.INFO]  = { enabled = false, icon = 'I' },
    --   [vim.diagnostic.severity.HINT]  = { enabled = true,  icon = 'H' },
    -- },

    -- Excludes buffers from the tabline
    -- exclude_ft = {'javascript'},
    -- exclude_name = {'package.json'},

    -- Hide inactive buffers and file extensions. Other options are `current` and `visible`
    -- hide = { extensions = true, inactive = true },

    -- Enable/disable icons
    -- if set to 'numbers', will show buffer index in the tabline
    -- if set to 'both', will show buffer index and icons in the tabline
    -- icons = true, -- this shows icons
    -- icons = 'numbers',
    -- icons = 'both',
    icons = false,

    -- If set, the icon color will follow its corresponding buffer
    -- highlight group. By default, the Buffer*Icon group is linked to the
    -- Buffer* group (see Highlighting below). Otherwise, it will take its
    -- default value as defined by devicons.
    icon_custom_colors = false,

    -- Configure icons on the bufferline.
    -- icon_separator_active = '▎',
    -- icon_separator_inactive = '▎',
    icon_separator_active = ' ',
    icon_separator_inactive = ' ',
    -- This makes the close tab button "invisible", but if you click right at the
    -- end of the filename, the buffer gets closed, because the button is there
    icon_close_tab = '',
    icon_close_tab_modified = '[+]',
    icon_pinned = ' 車',

    -- If true, new buffers will be inserted at the start/end of the list.
    -- Default is to insert after current buffer (both set to false).
    insert_at_end = true,
    insert_at_start = false,

    -- Sets the maximum and minimum padding width with which to surround each tab
    maximum_padding = 0,
    minimum_padding = 0,

    -- Sets the maximum buffer name length.
    maximum_length = 30,

    -- If set, the letters for each buffer in buffer-pick mode will be
    -- assigned based on their name. Otherwise or in case all letters are
    -- already assigned, the behavior is to assign letters in order of
    -- usability (see order below)
    semantic_letters = false,

    -- New buffer letters are assigned in this order. This order is
    -- optimal for the qwerty keyboard layout but might need adjustement
    -- for other layouts.
    letters = 'asdfhjklgçnmxcvbziowerutyqpASDFHJKLGÇNMXCVBZIOWERUTYQP',

    -- Sets the name of unnamed buffers. By default format is "[buffer X]"
    -- where X is the buffer number. But only a static string is accepted here.
    no_name_title = '[No Name]',
  })
end

local function setColors()
  vim.cmd([[
  hi BufferCurrent          guifg=#efefef   guibg=NONE
  hi BufferCurrentIndex     guifg=#599eff   guibg=NONE
  hi BufferCurrentMod       guifg=#efefef   guibg=NONE
  hi BufferCurrentSign      guifg=#599eff   guibg=NONE
  hi BufferCurrentTarget    guifg=red       guibg=NONE      gui=BOLD

  hi BufferVisible          guifg=#efefef   guibg=#6c6c6c
  hi BufferVisibleIndex     guifg=#efefef   guibg=#6c6c6c
  hi BufferVisibleMod       guifg=#efefef   guibg=#6c6c6c
  hi BufferVisibleSign      guifg=#efefef   guibg=#6c6c6c
  hi BufferVisibleTarget    guifg=red       guibg=#6c6c6c   gui=BOLD

  hi BufferInactive         guifg=#616163   guibg=#2e3436
  hi BufferInactiveIndex    guifg=#555555   guibg=#2e3436
  hi BufferInactiveMod      guifg=#616163   guibg=#2e3436
  hi BufferInactiveSign     guifg=#555555   guibg=#2e3436
  hi BufferInactiveTarget   guifg=red       guibg=#2e3436   gui=BOLD

  hi BufferTabpages         guifg=#599eff   guibg=#2e3436   gui=BOLD
  hi BufferTabpageFill      guifg=#616163   guibg=#bbc2cf

  """ Diagnostic icons
  " hi BufferCurrentERROR guibg=NONE guifg=#e78284 guibg=NONE
  " hi BufferCurrentWARN  guibg=NONE guifg=#e5c890 guibg=NONE
  " hi BufferCurrentINFO  guibg=NONE guifg=#99d1db guibg=NONE
  " hi BufferCurrentHINT  guibg=NONE guifg=#81c8be guibg=NONE
  " hi BufferVisibleERROR guibg=NONE guifg=#efefef guibg=#6c6c6c
  " hi BufferVisibleWARN  guibg=NONE guifg=#efefef guibg=#6c6c6c
  " hi BufferVisibleINFO  guibg=NONE guifg=#efefef guibg=#6c6c6c
  " hi BufferVisibleHINT  guibg=NONE guifg=#efefef guibg=#6c6c6c
  " hi BufferInactiveERROR guibg=NONE guifg=#616163 guibg=#2e3436
  " hi BufferInactiveWARN  guibg=NONE guifg=#616163 guibg=#2e3436
  " hi BufferInactiveINFO  guibg=NONE guifg=#616163 guibg=#2e3436
  " hi BufferInactiveHINT  guibg=NONE guifg=#616163 guibg=#2e3436
  ]])
end

return {
  setup = setup,
  setColors = setColors,
}
