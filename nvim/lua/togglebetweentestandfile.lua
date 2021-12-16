function _G.toggleBetweenTestAndFile()
  local filetype = vim.bo.filetype

  functions = {
    elixir = elixirFunction,
    ruby = rubyFunction,
  }

  if not functions[filetype] then
    print('Filetype '..filetype..' not supported')
    return
  end

  local path = functions[filetype]()
  print('Switching to '..path)
  vim.api.nvim_command('edit '..path)
end

function elixirFunction()
  local file_dir = vim.fn.expand('%:h')

  path = ''
  found = false
  for str in string.gmatch(file_dir, '[^/]+') do
    if found then path = path..str..'/'
    else
      if not found and str == 'test' then
        found = true
        path = path..'lib/'
        filename = vim.fn.expand('%:t'):gsub('_test.exs', '.ex')
      elseif not found and str == 'lib' then
        found = true
        path = path..'test/'
        filename = vim.fn.expand('%:t'):gsub('.ex', '_test.exs')
      end
    end
  end
  return path..filename
end

-- function rubyFunction()
--   Rails projects usually don't have such a predictable and silly folder
--   structures as a mix/phoenix project, so this does not actually work unless
--   it does.

--   local file_dir = vim.fn.expand('%:h')

--   path = ''
--   found = false
--   for str in string.gmatch(file_dir, '[^/]+') do
--     if found then path = path..str..'/'
--     else
--       if not found and str == 'spec' then
--         found = true
--         path = path..'app/'
--         filename = vim.fn.expand('%:t'):gsub('_spec.rb', '.rb')
--       elseif not found and str == 'app' then
--         found = true
--         path = path..'spec/'
--         filename = vim.fn.expand('%:t'):gsub('.rb', '_spec.rb')
--       end
--     end
--   end
--   return path..filename
-- end
