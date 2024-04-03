-- https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/

------ I've got no Roots. - MERTON, Alice
-- Array of file names indicating root directory. Modify to your liking.
local root_names = {
  '.styluaignore',
  'go.mod',
  'Makefile',
  '.git',
  '_darcs',
  '.hg',
  '.bzr',
  '.svn',
}

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

function GetProjectRootCache()
  return P(root_cache)
end

vim.api.nvim_create_user_command('GetProjectRootCache', GetProjectRootCache, {})

local function set_root()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return end

  path = vim.fs.dirname(path)

  -- Except inside .asdf, because when going to
  -- definition I don't want to set it as root
  local asdf_dir = os.getenv('ASDF_DIR')
  if asdf_dir then
    -- First check if using asdf
    if string.match(path, asdf_dir) then
      -- Now quits if it matches
      return
    end
  end

  -- If in git, just use root_dir and ignore root_names table.
  local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n$', '')
  if vim.v.shell_error == 0 then
    root_cache[path] = git_root
    vim.fn.chdir(git_root)
    return git_root
  end

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, {
      path = path,
      upward = true,
      stop = vim.loop.os_homedir(),
      limit = 1, -- stop on first find
    })[1]

    root = vim.fs.dirname(root_file)
  end

  if root == nil then return 'no roots' end

  root_cache[path] = root

  -- Set current directory
  vim.fn.chdir(root)
end

local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})

vim.api.nvim_create_autocmd('BufEnter', {
  group = root_augroup,
  callback = set_root,
  once = false,
})

-- When opening a file from cmd line, like this: vim /path/to/file,
-- the dir would be /path/to, even with BufEnter auto command.
-- From my tests, the dir would change after the BufEnter event ran,
-- so I'm setting this second autocmd, but to run only once.
-- Also, when vim is ran without a filepath, just "vim", it
-- does not fire this event, meaning that on first DirChanged it would
-- run this. So I'm checking if vim was opened with any arguments
-- using argc, which returns the number of FILES in the argument list.
-- Flags will not be counted, so both
-- `vim -O file1 file2` and `vim file1 file2` returns 2.
if vim.fn.argc() > 0 then
  vim.api.nvim_create_autocmd('DirChanged', {
    group = root_augroup,
    callback = function()
      set_root()
      -- If callback returns true,
      -- the autocmd is deleted once ran.
      -- return true
    end,
    -- But if the once option is set to true,
    -- it is also deleted afterwards.
    -- :h autocmd-once
    once = true,
  })
end
