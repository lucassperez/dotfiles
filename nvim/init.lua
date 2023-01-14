-- Useful to print tables
function P(value)
  print(vim.inspect(value))
  return value
end

local any_require_failed = false

local function protected_require(path)
  local ok, result = pcall(require, path)
  if not ok then
    -- Only print this the first time a pcall returned an error
    if not any_require_failed then print('ERROR!') end

    any_require_failed = true
    print('Could not require the path `'..path..'`')

    -- Print only first line of the error
    print('  '..string.sub(result, 1, string.find(result, '\n')))

    local file = io.open(vim.fn.stdpath('config')..'/nvim-require.log', 'a')
    if file then
      file:write('['..os.date('%Y-%m-%d-%H:%M:%S')..']: '..path..'\n')
      file:write(result)
      file:write('\n---\n')
      file:close()
    end
  end
end

-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

-- Sobre as cores:
-- https://icyphox.sh/blog/nvim-lua/

protected_require('keymappings')
protected_require('settings')
protected_require('commands') -- Vimscript used to create commands

-- protected_require('plugins.tokyonight')
protected_require('plugins.catppuccin')

protected_require('plugins')
protected_require('plugins.lsp')
protected_require('plugins.gitsigns')
protected_require('plugins.tree-sitter')
-- protected_require('plugins.tree-sitter.elixir')
protected_require('plugins.tree-sitter.typescript')
protected_require('plugins.cmp')
-- protected_require('plugins.luasnip')
protected_require('plugins.nvim-surround')
protected_require('plugins.nvim-autopairs')
protected_require('plugins.lexima')
protected_require('plugins.vim-closetag')
protected_require('plugins.lualine')
protected_require('plugins.Comment')
protected_require('plugins.tmux')
protected_require('plugins.nvim-various-textobjs')
-- protected_require('plugins.buftabline')
protected_require('plugins.barbar')
protected_require('plugins.telescope')
protected_require('plugins.nvim-tree')
-- protected_require('plugins.conjure')
-- protected_require('plugins.vim-sexp')
protected_require('plugins.undotree')
protected_require('plugins.colorizer')

-- Meus próprios scritpts
protected_require('helper-scripts.vtr.test')
protected_require('helper-scripts.vtr.linter')
protected_require('helper-scripts.vtr.from-git-generic')
protected_require('helper-scripts.vtr.execute-script')
protected_require('helper-scripts.vtr.send-line-to-tmux')
protected_require('helper-scripts.vtr.compile-file')
protected_require('helper-scripts.togglebetweentestandfile')
protected_require('helper-scripts.write-debugger-breakpoint')

if any_require_failed then
  print('---')
  print('Check file '..vim.fn.stdpath('config')..'/nvim-require.log for more information')
end
