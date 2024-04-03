local function tmuxShowPanesNumbersOnAttatchIfMultiplePanes()
  -- If tmux not running, exits.
  if os.getenv('TMUX') == nil then return end

  -- If command somehow fails, exits.
  -- If there is some tmux in the background, this command returns
  -- something, even if nvim is not inside tmux, so that's why the
  -- env var TMUX check above is necessary.
  local tmux_panes = io.popen('tmux list-panes')
  if tmux_panes == nil then return end

  -- If only one tmux pane, exits.
  local _ = tmux_panes:read()
  local second_read = tmux_panes:read()
  if second_read == nil then
    vim.notify('No other tmux panes', vim.log.levels.INFO)
    return -1
  end

  -- If more than 2 panes (at least two other than neovim itself),
  -- shows panes' numbers on screen.
  local third_read = tmux_panes:read()
  tmux_panes:close()
  if third_read then vim.cmd('silent !tmux display-panes') end

  -- When only exactly two panes, attaches directly.
  -- Using pcall so I can cancel the pane selection
  -- with <C-c> without getting a giant error message.
  pcall(vim.cmd.VtrAttachToPane)
end

local function autoAttachAndRunCommand(command, args, stringForm, isVim)
  -- I don't know how to use the lua version
  -- require('lazy').load('vim-tmux-runner')
  vim.cmd('Lazy load vim-tmux-runner')

  local attachedPane = vim.fn.VtrFnGetAttachedPane()
  if attachedPane == -1 then
    local canAttach = tmuxShowPanesNumbersOnAttatchIfMultiplePanes()
    if canAttach == -1 then
      return
    end
  else
    local check = os.execute("tmux list-panes -F '#{pane_index}' | grep -q '^" .. attachedPane .. "$'")
    if check > 0 then
      vim.notify('Attached pane does not exist anymore\n', vim.log.levels.WARN)
      local canAttach = tmuxShowPanesNumbersOnAttatchIfMultiplePanes()
      if canAttach == -1 then
        return
      end
    end
  end

  if stringForm then
    local commandString = string.format('%s %s \n', (isVim and ':call' or ':lua'), stringForm)
    vim.api.nvim_feedkeys(commandString, 'n', false)
  else
    command(args)
  end
end

--[[
  Rodar linter e testes automatizados de dentro do vim (tem que ter um "runner" setado antes)
  Dependendo do tipo de arquivo, será feito algo diferente.
  Linguagens configuradas:
  - Ruby (rubocop e rspec)
  - Elixir (credo/formatter e test)
  Mnemônicos: rubocop all (rua), rubocop file (ruf), rubocop main/master (rum)
              rspec all (ra), rspec (rs), rspec near (rn),
              rspec directory (rd), rspec main/master (rm)
              attach (<leader>a)

  Basicamente, "ru" = linter (RUbocop) e "r" = testes (Rspec)

  Setar um runner pro Vim Tmux Runner e mandar alguns sinais úteis, como
  Control + d e Control + c
]]

local f = autoAttachAndRunCommand

vim.keymap.set(
  'n',
  '<leader>a',
  tmuxShowPanesNumbersOnAttatchIfMultiplePanes,
  { desc = 'VtrAttach ou mostra os números dos paineis caso haja mais que dois' }
)

vim.keymap.set('n', '<A-d>', function() f(vim.cmd.VtrSendCtrlD) end, { desc = 'VtrSendCtrlD' })
vim.keymap.set('n', '<A-c>', function() f(vim.cmd.VtrSendCtrlC) end, { desc = 'VtrSendCtrlC' })

-- linter all & linter this file
vim.keymap.set('n', '<leader>rua', function ()
  vim.cmd('silent!wa')
  f(RunLinter, {}, 'RunLinter {}')
end)

vim.keymap.set('n', '<leader>ruf', function ()
  vim.cmd('silent!wa')
  f(RunLinter, { cur_file = true }, 'RunLinter { cur_file = true }')
end)

-- The same as "ruf". The "n" stands for near, in case of linter
-- for me it just makes sense to be the whole file.
vim.keymap.set('n', '<leader>ruf', function ()
  vim.cmd('silent!wa')
  f(RunLinter, { cur_file = true }, 'RunLinter { cur_file = true }')
end)


-- Test all, test this file, test this file this line & test this directory

vim.keymap.set('n', '<leader>ra', function ()
  vim.cmd('silent!wa')
  f(RunAutomatedTest, {}, 'RunAutomatedTest {}')
end)

vim.keymap.set('n', '<leader>rs', function ()
  vim.cmd('silent!wa')
  f(RunAutomatedTest, { cur_file = true }, 'RunAutomatedTest { cur_file = true }')
end)

vim.keymap.set('n', '<leader>rn', function ()
  vim.cmd('silent!wa')
  f(RunAutomatedTest, { cur_file = true, cur_line = true }, 'RunAutomatedTest { cur_file = true, cur_line = true }')
end)

vim.keymap.set('n', '<leader>rd', function ()
  vim.cmd('silent!wa')
  f(RunAutomatedTest, { cur_dir = true }, 'RunAutomatedTest { cur_dir = true }')
end)

vim.keymap.set('n', '<leader>rp', function ()
  vim.cmd('silent!wa')
  f(RunLastTest, nil, 'RunLastTest()')
end)

-- Pegando os arquivos no diff com a main/master e executando testes/linters
-- Mmenônicos: rspec-main (rm) e rubocop-main (rum)

vim.keymap.set('n', '<leader>rm', function ()
  vim.cmd('silent!wa')
  f(FromGit.genericTest, nil, 'FromGit.genericTest()')
end)

vim.keymap.set('n', '<leader>rum', function ()
  vim.cmd('silent!wa')
  f(FromGit.genericLinter, 'FromGit.genericLinter()')
end)

-- Run last command executado no painel "anexado"
-- Na verdade simplesmente executa !!, que só vai funcionar num shell, mesmo
vim.keymap.set('n', '<leader>rl', function ()
  vim.cmd('silent!wa')
  f(vim.cmd.VtrSendCommand, '!!', "VtrSendCommand('!!')", true)
end)

-- Executa o arquivo como um script a depender do seu "filetype"
-- Ver o script para detalhes

vim.keymap.set('n', '<leader>rr', function ()
  vim.cmd('silent!wa')
  f(ExecuteFileAsScript, nil, 'ExecuteFileAsScript()')
end)

vim.keymap.set('n', '<leader>R', function ()
  vim.cmd('silent!wa')
  f(AutoExecuteOnSave, nil, 'AutoExecuteOnSave()')
end)

-- Tenta compilar o arquivo a depender do seu "filetype"
vim.keymap.set('n', '<leader>rc', function ()
  vim.cmd('silent!wa')
  f(CompileFile, nil, 'CompileFile')
end)
