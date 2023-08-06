local elixir_pipe_pry = [[|> fn x -><CR>require IEx; IEx.pry()<CR>x<CR>end.()]]
vim.keymap.set(
  'n',
  ',,bp',
  'o' .. elixir_pipe_pry .. '<C-c>',
  { noremap = true, desc = 'Elixir: Escreve aquele pipe esperto com pry na linha de baixo' }
)
vim.keymap.set(
  'n',
  ',,BP',
  'O' .. elixir_pipe_pry .. '<C-c>',
  { noremap = true, desc = 'Elixir: Escreve aquele pipe esperto com pry na linha de cima' }
)
vim.keymap.set(
  'n',
  ',,Bp',
  'O' .. elixir_pipe_pry .. '<C-c>',
  { noremap = true, desc = 'Elixir: Escreve aquele pipe esperto com pry na linha de cima' }
)
vim.keymap.set(
  'n',
  ',,bP',
  'O' .. elixir_pipe_pry .. '<C-c>',
  { noremap = true, desc = 'Elixir: Escreve aquele pipe esperto com pry na linha de cima' }
)

vim.keymap.set(
  'n',
  ',io',
  'oIO.inspect(, label: "@@")<C-c>F,',
  { noremap = true, desc = 'Elixir: Escreve inspect com label na linha de baixo' }
)
vim.keymap.set(
  'n',
  ',IO',
  'OIO.inspect(, label: "@@")<C-c>F,',
  { noremap = true, desc = 'Elixir: Escreve inspect com label na linha de cima' }
)
vim.keymap.set(
  'n',
  ',Io',
  'OIO.inspect(, label: "@@")<C-c>F,',
  { noremap = true, desc = 'Elixir: Escreve inspect com label na linha de cima' }
)
vim.keymap.set(
  'n',
  ',iO',
  'OIO.inspect(, label: "@@")<C-c>F,',
  { noremap = true, desc = 'Elixir: Escreve inspect com label na linha de cima' }
)

vim.keymap.set('n', ',,io', 'o|> IO.inspect(label: "@@")<C-c>', {
  noremap = true,
  desc = 'Elixir: Escreve aquele pipe esperto com inspect com label na linha de baixo',
})
vim.keymap.set('n', ',,IO', 'O|> IO.inspect(label: "@@")<C-c>', {
  noremap = true,
  desc = 'Elixir: Escreve aquele pipe esperto com inspect com label na linha de cima',
})
vim.keymap.set('n', ',,Io', 'O|> IO.inspect(label: "@@")<C-c>', {
  noremap = true,
  desc = 'Elixir: Escreve aquele pipe esperto com inspect com label na linha de cima',
})
vim.keymap.set('n', ',,iO', 'O|> IO.inspect(label: "@@")<C-c>', {
  noremap = true,
  desc = 'Elixir: Escreve aquele pipe esperto com inspect com label na linha de cima',
})
