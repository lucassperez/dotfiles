local textobjs = require('various-textobjs')

textobjs.setup({
  useDefaultKeymaps = false,
})

-- Functions that differentiate inner and outer
-- reiceves a boolean parameter where inner is
-- true and outer is false
local inner = true
local outer = false

-- exception: indentation textobj requires two parameters, first for exclusion of the
-- starting border, second for the exclusion of ending border
vim.keymap.set({ 'o', 'x' }, 'ii', function() textobjs.indentation(true, true) end)
vim.keymap.set({ 'o', 'x' }, 'ai', function() textobjs.indentation(false, true) end)

local function map(function_name, keys, opt)
  vim.keymap.set({ 'o', 'x' }, keys, function() textobjs[function_name](opt) end)
end

map('entireBuffer', 'gG')

-- Value in key-value pair
map('value', 'iv', inner)
map('value', 'av', outer)

-- Key in key-value pair
map('key', 'ik', inner)
map('key', 'ak', outer)

map('number', 'in', inner)
map('number', 'an', outer)

-- [[]]
map('doubleSquareBrackets', 'iD', inner)
map('doubleSquareBrackets', 'aD', outer)

-- Like built in vim word 'w' buf treating -, _ or
-- . as word delimiters and only part of camelcase
map('subword', 'iS', inner)
map('subword', 'aS', outer)

-- Column down until indent or shorter line.
-- Accepts {count} for multiple columns.
map('column', '|')

-- I'm not sure what this one does
map('shellPipe', 'iP', inner)
map('shellPipe', 'aP', outer)

vim.keymap.set('n', 'gx', function()
  textobjs.url() -- select URL
  local foundURL = vim.fn.mode():find('v') -- only switches to visual mode if found
  if foundURL then
    vim.cmd.normal({ '"zy', bang = true }) -- retrieve URL with "z as intermediary
    -- Substitue # for \#, since # alone does not work well in vim
    local url = vim.fn.getreg('z'):gsub('#', '\\#')

    vim.cmd('!xdg-open "'..url..'"')
  end
end, { desc = 'Smart URL Opener' })
