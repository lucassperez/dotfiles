local function elixirFunction()
  local filename = vim.fn.expand('%')
  local result
  if filename:match('test/.*') then
    result = filename:gsub('^(.*)test/(.*)_test.exs$', 'lib/%2.ex')
  else
    result = filename:gsub('^(.*)lib/(.*).ex$', 'test/%2_test.exs')
  end
  return result
end

-- Switches to test files with the same name and on the same directory,
-- but with ".test" as file extension
local function tsReactFunction()
  local file_dir = vim.fn.expand('%:h')
  local file_name = vim.fn.expand('%:t')
  local extension = vim.fn.expand('%:e')

  local path = ''
  if string.match(file_name, '%w*%.test%.'..extension..'$') then
    path = string.gsub(file_name, '%.test%.'..extension..'$', '.'..extension)
  elseif string.match(file_name, '%w*%.'..extension..'$') then
    path = string.gsub(file_name, '%.'..extension..'$', '.test.'..extension)
  end

  if path == '' then return nil end
  return file_dir..'/'..path
end

local function clojureFunction()
  local filename = vim.fn.expand('%')
  local result
  if filename:match('test/.*') then
    result = filename:gsub('^(.*)test/(.*)_test.clj$', 'src/%2.clj')
  else
    result = filename:gsub('^(.*)src/(.*).clj$', 'test/%2_test.clj')
  end
  return result
end

local function rubyFunction()
  local filename = vim.fn.expand('%')
  local result
  if filename:match('spec.*_spec.rb$') then
    result = filename:gsub('^spec/(.*)_spec.rb$', 'app/%1.rb')
  else
    result = filename:gsub('^app/(.*).rb$', 'spec/%1_spec.rb')
  end
  return result
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

local filenameFunctions = {
    elixir = elixirFunction,
    ruby = rubyFunction,
    typescriptreact = tsReactFunction,
    typescript = tsReactFunction,
    clojure = clojureFunction,
}

local function toggleBetweenTestAndFile()
  local filetype = vim.bo.filetype

  if not filenameFunctions[filetype] then
    print('Filetype '..filetype..' not supported')
    return
  end

  local path = filenameFunctions[filetype]()
  if path == nil then
    print('Path for the other file not found. Is your current working directory the project\'s root directory?')
  else
    print('Switching to '..path)
    vim.api.nvim_command('edit '..path)
  end
end

TestAndFile = {
  toggle = toggleBetweenTestAndFile,
  filenamesFunctions = filenameFunctions,
}
