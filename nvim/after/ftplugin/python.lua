-- https://www.reddit.com/r/neovim/comments/17aponn/i_feel_like_leadmultispace_deserves_more_attention/?utm_source=share&utm_medium=web2x&context=3

-- For python files, Vim has a builtin ftplugin file where it sets the
-- shiftwidth option to 4, overriding other values in init.vim or init.lua etc:
-- (vim instal path)/share/nvim/runtime/ftplugin/python.vim
-- For example, it could be in .asdf/installs/neovim/0.9.1/share/nvim/runtime/ftplugin/python.vim
-- To find out, one can always nvim --startuptime start-log -- arquivo-python.py start-log
-- and try to find loaded files there related to python.
local lead = vim.opt_local.listchars:get().leadmultispace
lead = lead:gsub('%s$', '') -- remove all trailing spaces from `lead`
for _ = 1, vim.bo.shiftwidth - 1 do
  lead = lead .. ' '
end
vim.opt_local.listchars:append({ leadmultispace = lead })
