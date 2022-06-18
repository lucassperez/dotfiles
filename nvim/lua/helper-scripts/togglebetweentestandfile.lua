function toggleBetweenTestAndFile()
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
  if path == nil then
    print('Path for the other file not found. Is your current working directory the project\'s root directory?')
  else
    print('Switching to '..path)
    vim.api.nvim_command('edit '..path)
  end
end

function elixirFunction()
  local file_dir = vim.fn.expand('%:h')

  path = ''
  found = false
  for str in string.gmatch(file_dir, '[^/]+') do
    if found then
      path = path..str..'/'
    else
      if str == 'test' then
        found = true
        path = 'lib/'..path
        filename = vim.fn.expand('%:t'):gsub('_test%.exs', '.ex')
      elseif str == 'lib' then
        found = true
        path = 'test/'..path
        filename = vim.fn.expand('%:t'):gsub('%.ex', '_test.exs')
      end
    end
  end
  if filename == nil then return nil end
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
--     if found then
--       path = path..str..'/'
--     else
--       if not found and str == 'spec' then
--         found = true
--         path = 'app/'..path
--         filename = vim.fn.expand('%:t'):gsub('_spec%.rb$', '.rb')
--       elseif not found and str == 'app' then
--         found = true
--         path = 'spec/'..path
--         filename = vim.fn.expand('%:t'):gsub('%.rb$', '_spec.rb')
--       end
--     end
--   end
--   return path..filename
-- end
