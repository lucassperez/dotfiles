local function init()
  -- FzfLua resume volta a última coisa, interessante hein.
  -- Dá até pra passar como argumento, tipo FzfLua files resume=true

  -- Can't make git_files show untracked files )=
  -- Simply passing cmd = 'git ls-files --exclude-standard --cached --others'
  -- is not working, not even adding git -C to the git root level.
  -- This should be perfect, but still doesn't work.
  -- git -C `git rev-parse --show-toplevel` ls-files --exclude-standard --cached --others
  -- I thought about having a check, if in git repo, use git_files, otherwise,
  -- use normal files. But since I can't make it show untracked files, I'm
  -- just using files. By default, it apparently respects .gitignore, but we
  -- change it by pressing control+g.
  -- local root = vim.fn.system('git rev-parse --show-toplevel')
  -- if vim.v.shell_error == 0 then
  --   require('fzf-lua').git_files({ cwd = root:gsub('\n$', '') })
  -- else
  --   require('fzf-lua').files()
  -- end
  vim.keymap.set('n', '<C-p>', function()
    require('fzf-lua').files()
  end, { desc = '[FzfLua] Abre o FzfLua files' })

  vim.keymap.set('n', '<C-f>', function()
    -- Not sure the differentece of live_grep and live_grep_native
    require('fzf-lua').live_grep_native()
  end, { desc = '[FzfLua] Abre o FzfLua live_grep_native' })

  vim.keymap.set('n', '<leader>p', function()
    require('fzf-lua').buffers({ sort_lastused = true })
  end, { desc = '[FzfLua] Abre o FzfLua buffers' })

  vim.keymap.set('n', '<leader>h', function()
    require('fzf-lua').oldfiles({ sort_lastused = true })
  end, { desc = '[FzfLua] Abre o FzfLua oldfiles' })
end

local function setup()
  require('fzf-lua').setup({
    keymap = {
      builtin = {
        ['<C-d>'] = 'preview-page-down',
        ['<C-u>'] = 'preview-page-up',
        ['<C-_>'] = 'toggle-preview',

        -- I did not want to override the defaults, so I added mine
        -- and then the default present on the readme.
        -- neovim `:tmap` mappings for the fzf win
        ['<F1>'] = 'toggle-help',
        ['<F2>'] = 'toggle-fullscreen',
        -- Only valid with the 'builtin' previewer
        ['<F3>'] = 'toggle-preview-wrap',
        ['<F4>'] = 'toggle-preview',
        -- Rotate preview clockwise/counter-clockwise
        ['<F5>'] = 'toggle-preview-ccw',
        ['<F6>'] = 'toggle-preview-cw',
        ['<S-down>'] = 'preview-page-down',
        ['<S-up>'] = 'preview-page-up',
        ['<S-left>'] = 'preview-page-reset',
      },
      fzf = {
        -- fzf '--bind=' options
        ['ctrl-z'] = 'abort',
        ['ctrl-u'] = 'unix-line-discard',
        ['ctrl-f'] = 'half-page-down',
        ['ctrl-b'] = 'half-page-up',
        ['ctrl-a'] = 'beginning-of-line',
        ['ctrl-e'] = 'end-of-line',
        ['alt-a'] = 'toggle-all',
        -- Only valid with fzf previewers (bat/cat/git/etc)
        ['f3'] = 'toggle-preview-wrap',
        ['f4'] = 'toggle-preview',
        ['shift-down'] = 'preview-page-down',
        ['shift-up'] = 'preview-page-up',
      },
    },
    winopts = {
      width = 0.95,
      preview = {
        -- The percentage that the PREVIEW window takes when opening.
        -- These numbers do not reflect the preview window size upon rotation,
        -- only at opening, as far as I could tell.
        vertical = 'down:45%', -- up|down:size
        horizontal = 'right:50%', -- right|left:size

        -- Layout horizontal the preview is by the side of the input
        -- Layout vertical the preview is on top/below of the input
        -- Flex apparently it tries horizontal,
        -- but if window is too small, it opens vertical
        layout = 'flex', -- horizontal|vertical|flex

        delay = 10, -- delay(ms) displaying the preview, prevents lag on fast scrolling

        -- on_create = function()
        -- called once upon creation of the fzf main window
        -- can be used to add custom fzf-lua mappings, e.g:
        --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
        -- end,
        -- called once *after* the fzf interface is closed
        -- on_close = function() ... end
      },
    },
  })

  vim.cmd([[
  hi clear FzfLuaCursorLine
  hi link FzfLuaCursorLine Visual
  hi FzfLuaCursorLine guibg=#61677d gui=NONE
  hi FzfLuaCursor guifg=NONE guibg=NONE
  ]])
end

return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  init = init,
  config = setup,
}
