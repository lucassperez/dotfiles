if vim.fn.argc() > 0 then
  return
end

local vim_version = vim.version()
if vim_version.minor < 12 then
  return
end

local custom_screen = true
if not custom_screen then
  return
end

--[[
The idea is to create a floating window
with the text the same as the old intro,
and then dismiss this floating window when
we enter insert mode, load a file into the buffer,
or move the cursor to another window.
The latter avoids weird behaviour if we open a new
split. The old intro also disappeared when doing this.
]]

vim.opt.shortmess:append('I')

local function set_intro_highlights()
  vim.api.nvim_set_hl(0, 'IntroTitle', { fg = '#a6d189' })
  vim.api.nvim_set_hl(0, 'IntroText', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'IntroCode', { link = 'Identifier' })
  vim.api.nvim_set_hl(0, 'IntroSpecial', { link = 'SpecialKey' })

  vim.api.nvim_set_hl(0, 'IntroBorder', {
    fg = vim.api.nvim_get_hl(0, { name = 'FloatBorder' }).fg,
    bg = 'NONE'
  })
  vim.api.nvim_set_hl(0, 'IntroSeparator', {
    fg = '#aaaaaa',
    bg = 'NONE'
  })

  vim.api.nvim_set_hl(0, 'IntroNormal', {
    fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg,
    bg = 'NONE'
  })
end

local intro = {
  win = nil,
  buf = nil,
  ns = nil,
  text = {
    lines = nil,
    largest_line_len = 0,
  },
  group = nil,
}

intro.ns = vim.api.nvim_create_namespace('IntroOverlayNS')
intro.group = vim.api.nvim_create_augroup('IntroOverlay', { clear = true })

intro.text.lines = {
  { { '                 NVIM ' .. vim_version.build, 'IntroTitle' } },
  { { '───────────────────────────────────────────────', 'IntroSeparator' } },
  { { ' Nvim is open source and freely distributable!', 'IntroText' } },
  { { '           https://neovim.io/#chat', 'IntroTitle' } },
  { { '───────────────────────────────────────────────', 'IntroSeparator' } },
  {
    { 'type  ', 'IntroText', },
    { ':', 'IntroSpecial', },
    { 'help nvim', 'IntroCode' },
    { '<Enter>', 'IntroSpecial' },
    { '       if you are new!', 'IntroText' },
  },
  {
    { 'type  ', 'IntroText' },
    { ':', 'IntroSpecial', },
    { 'checkhealth', 'IntroCode' },
    { '<Enter>', 'IntroSpecial' },
    { '     to optimize Nvim', 'IntroText' },
  },
  {
    { 'type  ', 'IntroText' },
    { ':', 'IntroSpecial', },
    { 'q', 'IntroCode' },
    { '<Enter>', 'IntroSpecial' },
    { '               to exit', 'IntroText' },
  },
  {
    { 'type  ', 'IntroText' },
    { ':', 'IntroSpecial', },
    { 'help', 'IntroCode' },
    { '<Enter>', 'IntroSpecial' },
    { '            for help', 'IntroText' },
  },
  { { '───────────────────────────────────────────────', 'IntroSeparator' } },
  {
    { 'type  ', 'IntroText' },
    { ':', 'IntroSpecial', },
    { 'help news', 'IntroCode' },
    { '<Enter>', 'IntroSpecial' },
    { (' to see changes in v%d.%d'):format(vim_version.major, vim_version.minor), 'IntroText' },
  },
  { { '───────────────────────────────────────────────', 'IntroSeparator' } },
  { { '         Help poor children in Uganda!', 'IntroText' } },
  {
    { 'type  ', 'IntroText' },
    { ':', 'IntroSpecial', },
    { 'help Kuwasha', 'IntroCode' },
    { '<Enter>', 'IntroSpecial' },
    { '    for information', 'IntroText' },
  },
}

local function create_intro_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  local line_len

  for i, text in ipairs(intro.text.lines) do
    vim.api.nvim_buf_set_lines(buf, i - 1, i - 1, false, { '' })
    vim.api.nvim_buf_set_extmark(buf, intro.ns, i - 1, 0, {
      virt_text = text,
      virt_text_pos = 'overlay',
      virt_text_win_col = 1,
    })
    line_len = vim.fn.strchars(text[1][1])
    if line_len > intro.text.largest_line_len then
      intro.text.largest_line_len = line_len
    end
  end

  return buf
end

local function create_intro_win(row, col, width, height)
  local win = vim.api.nvim_open_win(intro.buf, false, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    -- border = 'none',
    border = 'rounded',
    focusable = false,
    noautocmd = true,
  })
  -- Transparent background only for the intro floating window
  vim.wo[win].winhighlight = 'NormalFloat:IntroNormal,FloatBorder:IntroBorder'
  return win
end

local function hide_intro()
  if intro.win and vim.api.nvim_win_is_valid(intro.win) then
    vim.api.nvim_win_close(intro.win, true)
    intro.win = nil
  end
end

local function render_intro()
  if not intro.buf or not vim.api.nvim_buf_is_valid(intro.buf) then
    -- I put this comment here so stylua
    -- does not make this a one liner.
    -- I usually don't mind it, but this line
    -- in particular is just too big.
    intro.buf = create_intro_buf()
  end

  local width = intro.text.largest_line_len + 2
  local height = #intro.text.lines

  -- I'm subtracting one to respect the ~ in the signal column
  local usable_width = vim.o.columns - 1

  -- Hide if terminal is too small
  -- That +6 is also kind of magical, and without it
  -- it gets too squished before closing it if the
  -- terminal window gets shorter.
  if usable_width < width or vim.o.lines < height + 6 then
    hide_intro()
    return
  end

  local row = math.floor((vim.o.lines - height) / 3)
  local col = math.floor((usable_width - width) / 2)

  if not intro.win or not vim.api.nvim_win_is_valid(intro.win) then
    intro.win = create_intro_win(row, col, width, height)
    return
  end

  vim.api.nvim_win_set_config(intro.win, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
  })
end

local function cleanup_intro()
  hide_intro()

  if intro.group then
    -- When opening some help pages, this deletion raised saying
    -- the augroup was already deleted... But this didn't
    -- happend when opening a file or a split or by typing.
    -- I don't what causes it, but I wrapped in a pcall to
    -- silently ignore it. Error handling at its finest.
    pcall(vim.api.nvim_del_augroup_by_id, intro.group)
    intro.group = nil
  end

  if intro.buf and vim.api.nvim_buf_is_valid(intro.buf) then
    if intro.ns then
      vim.api.nvim_buf_clear_namespace(intro.buf, intro.ns, 0, -1)
      intro.ns = nil
    end

    vim.api.nvim_buf_delete(intro.buf, { force = true })
    intro.buf = nil
  end

  intro.win = nil
  intro.text.lines = nil
  intro.text.largest_line_len = nil
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    set_intro_highlights()
    render_intro()

    vim.api.nvim_create_autocmd('VimResized', {
      group = intro.group,
      callback = render_intro,
    })

    -- If you want to recolor the intro when changing colorscheme,
    -- uncomment the following block of code.
    -- vim.api.nvim_create_autocmd('ColorScheme', {
    --   group = intro.group,
    --   callback = set_intro_highlights,
    -- })

    vim.api.nvim_create_autocmd({
      'InsertCharPre',
      'BufReadPre',
      'CursorMoved',
    }, {
      group = intro.group,
      once = true,
      callback = function()
        -- InsertCharPre raises some error when we try to
        -- close a window during that event, so I used
        -- vim.schedule to avoid the so called "textlock",
        -- as :h vim.schedule itself suggests.
        vim.schedule(cleanup_intro)
      end,
    })
  end,
})
