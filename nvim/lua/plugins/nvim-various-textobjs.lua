local textobjs = require('various-textobjs')

textobjs.setup({
  useDefaultKeymaps = false,
  -- lookForwardLines = 5, -- Set to 0 to only look in the current line.
})

-- The indentation textobj requires two parameters, first for exclusion of the
-- starting border, second for the exclusion of ending border
vim.keymap.set({ 'o', 'x' }, 'ii', function()
  textobjs.indentation('inner', 'inner')
end)
vim.keymap.set({ 'o', 'x' }, 'ai', function()
  textobjs.indentation('outer', 'outer')
end)

local function map(function_name, keys, opt, desc)
  if desc == nil then
    desc = function_name
  else
    desc = function_name .. ': ' .. desc
  end

  vim.keymap.set({ 'o', 'x' }, keys, function()
    textobjs[function_name](opt)
  end, { desc = '[VariousTextObjs] '.. desc })
end

map('entireBuffer', 'gG', nil, 'O buffer inteiro')

-- Value in key-value pair
map('value', 'v', 'inner', 'Valor em um par Chave-Valor')
map('value', 'V', 'inner', 'Valor em um par Chave-Valor')
map('value', 'iv', 'inner', 'Valor em um par Chave-Valor')
map('value', 'av', 'outer', 'Valor em um par Chave-Valor')

-- Key in key-value pair
map('key', 'K', 'inner',  'Chave em um par Chave-Valor')
map('key', 'ik', 'inner', 'Chave em um par Chave-Valor')
map('key', 'ak', 'outer', 'Chave em um par Chave-Valor')

map('number', 'in', 'inner', 'Número')
map('number', 'an', 'outer', 'Número')

-- [[]]
map('doubleSquareBrackets', 'iD', 'inner', 'Duplo colchetes')
map('doubleSquareBrackets', 'aD', 'outer', 'Duplo colchetes')

-- Like built in vim word 'w' buf treating -, _ or
-- . as word delimiters and only part of camelcase
map('subword', 'iS', 'inner', 'Como `w` padrão do vim, só que considerando -, _ e . como delimitadores')
map('subword', 'aS', 'outer', 'Como `w` padrão do vim, só que considerando -, _ e . como delimitadores')

-- Column down until indent or shorter line.
-- Accepts {count} for multiple columns.
map('column', '|', nil, 'Desce em linha vertical até achar uma linha mais curta. Aceita {conta} para múltiplas colunas')

-- I'm not sure what this one does
map('shellPipe', 'iP', 'inner')
map('shellPipe', 'aP', 'outer')

vim.keymap.set('n', 'gx', function()
  textobjs.url() -- select URL
  local foundURL = vim.fn.mode():find('v') -- only switches to visual mode if found
  if foundURL then
    vim.cmd.normal({ '"zy', bang = true }) -- retrieve URL with "z as intermediary
    -- Substitue # for \#, since # alone does not work well in vim
    local url = vim.fn.getreg('z'):gsub('#', '\\#')

    vim.cmd('!xdg-open "' .. url .. '"')
  end
end, { desc = '[VariousTextObjs] url: Abridor esperto de URL' })
