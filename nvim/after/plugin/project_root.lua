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

local function change_dir_if_different(path)
  -- Changed from vim.fn.chdir to vim.cmd.lcd
  -- With lcd, we have to check with getcwd(0) instead of just getcwd()

  local current = vim.fn.getcwd(0)
  if current ~= path then
    vim.cmd.lcd(path)
  end
end

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

function GetProjectRootCache()
  return P(root_cache)
end

vim.api.nvim_create_user_command('GetProjectRootCache', GetProjectRootCache, {})

local function escape(path)
  -- If path includes a dot, the lua pattern will treat it
  -- as the wilcard. So if path is ~/.config/dir as we try
  -- to match it with something, it will match with ~/aconfig/dir etc.
  -- vim.pesc should fix that.
  return vim.pesc(path)
end

local function normalize(path)
  -- fs_realpath deals with symlinks
  return vim.loop.fs_realpath(path) or path
end

local function set_root()
  local full_path = vim.api.nvim_buf_get_name(0)
  if full_path == '' then return end

  full_path = normalize(full_path)

  -- Exception when inside .asdf, because when going to
  -- definition I don't want to set it as root.
  local asdf_dir = os.getenv('ASDF_DIR')
  if asdf_dir then -- First check if using asdf
    if string.match(full_path, '^' .. escape(normalize(asdf_dir))) then
      return
    end
  end

  local dir_path = vim.fs.dirname(full_path)

  local cached = root_cache[dir_path]
  if cached then
    change_dir_if_different(cached)
    return cached
  end

  local config_path = normalize(vim.fn.stdpath('config'))
  if string.match(full_path, '^'..escape(config_path)) then
    root_cache[dir_path] = config_path
    change_dir_if_different(config_path)
    return config_path
  end

  -- If in git, just use root_dir and ignore root_names table.
  local git_root = vim.fn.system(
    'git -C ' .. vim.fn.shellescape(dir_path) .. ' rev-parse --show-toplevel'
  ):gsub('\n$', '')
  if vim.v.shell_error == 0 then
    root_cache[dir_path] = git_root
    change_dir_if_different(git_root)
    return git_root
  end

  local root
  local root_file = vim.fs.find(root_names, {
    path = dir_path,
    upward = true,
    stop = vim.loop.os_homedir(),
    limit = 1, -- stop on first find
  })[1]

  if root_file then
    root = vim.fs.dirname(root_file)
  end

  if root == nil then return 'no roots' end

  root_cache[dir_path] = root
  change_dir_if_different(root)
end

local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})

vim.api.nvim_create_autocmd('VimEnter', {
  group = root_augroup,
  callback = set_root,
  once = true,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = root_augroup,
  callback = set_root,
  once = false,
})

-- When opening symlinks, sometimes things are weird.
-- I can't use :BlameToggle when opening a symlink even though
-- the original file is inside a git directory.
-- The code below would solve it, but also looks a little extreme.
-- vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
--   callback = function()
--     local old = vim.api.nvim_buf_get_name(0)
--     local real = vim.loop.fs_realpath(old)
--     -- If opens a symlink, follows it and rename the buffer
--     if real and real ~= old then
--       vim.api.nvim_buf_set_name(0, real)
--     end
--   end,
-- })
