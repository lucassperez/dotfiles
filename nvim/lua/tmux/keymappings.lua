--[[
  Rodar linter e testes automatizados de dentro do vim
  Mnemônicos: rubocop all (rua), rubocop file (ruf), rubocop main/master (rum)
              rspec all (ra), rspec (rs), rspec near (rn),
              rspec directory (rd), rspec main/master (rm)
              attach (<leader>a)

  Basicamente, "ru" = linter (RUbocop) e "r" = testes (Rspec)
]]

local function ex(str)
  return function()
    vim.cmd('silent!wa')
    -- This goes to history, nvim_feedkeys does not
    -- Another option was vim.fn.histadd
    vim.api.nvim_input(':' .. str .. '\n')
  end
end

-- TmuxAttach

vim.keymap.set('n', '<leader>a', ':TmuxAttach<CR>', { silent = true, desc = 'Fixa painel do tmux' })

-- Linter

vim.keymap.set('n', '<leader>rua', ex('TmuxLinter all'), { desc = '[Tmux] TmuxLinter all' })
vim.keymap.set('n', '<leader>ruf', ex('TmuxLinter file'), { desc = '[Tmux] TmuxLinter current file' })
-- The same as "ruf". The "n" stands for near, in case of linter
-- for me it just makes sense to be the whole file.
vim.keymap.set('n', '<leader>run', ex('TmuxLinter line'), { desc = '[Tmux] TmuxLinter near (current file)' })

-- Test

vim.keymap.set('n', '<leader>ra', ex('TmuxTest all'), { desc = '[Tmux] TmuxTest all' })
vim.keymap.set('n', '<leader>rs', ex('TmuxTest file'), { desc = '[Tmux] TmuxTest current file' })
vim.keymap.set('n', '<leader>rn', ex('TmuxTest line'), { desc = '[Tmux] TmuxTest near (current line)' })
vim.keymap.set('n', '<leader>rd', ex('TmuxTest dir'), { desc = '[Tmux] TmuxTest current dir' })
vim.keymap.set('n', '<leader>rp', ex('TmuxTest last'), { desc = '[Tmux] TmuxTest last test (cached in nvim)' })

-- FromGitGeneric

vim.keymap.set('n', '<leader>rm', ex('FromGitGeneric test'), { desc = '[Tmux] Run test files from git diff' })
vim.keymap.set('n', '<leader>rum', ex('FromGitGeneric linter'), { desc = '[Tmux] Run linter on files from git diff' })

-- Run last command executado no painel "anexado"
-- Na verdade simplesmente executa !!, que só vai funcionar num shell, mesmo

vim.keymap.set('n', '<leader>rl', ex([[TmuxSend ]]), { desc = '[Tmux] Run last command (Ctrl-P in shell)' })

-- ExecuteFile as script

vim.keymap.set('n', '<leader>rr', ex('TmuxExecuteFile'), { desc = '[Tmux] ExecuteFile as script using shebang or trying to guess from filetype, if supported' })
vim.keymap.set('n', '<leader>R', ex('TmuxExecuteFile toggle'), { desc = '[Tmux] ExecuteFile as script automatically on save' })
