-- Switched to mini.comment because
-- it has a nice text object thing
-- Although Comment.nvim is very powerful with
-- its ignore, since it can also receive a function!
-- Comment.nvim also has the "comment block", which
-- is a nice to have.
require('Comment').setup({
  padding = true,
  -- don't comment blank lines with '^$'
  ignore = '^$',
})
