require('blame').setup({
  merge_consecutive = true,
  date_format = '%d/%m/%Y',
  virtual_style = 'float',
  commit_detail_view = 'current',
  format = function(blame)
    -- hash = 'e101b2ed9cdd29a37de596b95a6ec27f1c3f82ae',
    -- author = 'FabijanZulj',
    -- ['author-mail'] = '<38249221+FabijanZulj@users.noreply.github.com>',
    -- ['author-time'] = 1692005070,
    -- ['author-tz'] = '+0200',
    -- committer = 'GitHub',
    -- ['committer-mail'] = '<noreply@github.com>',
    -- ['committer-time'] = 1692005070,
    -- date = '2024-31-03 03:25',
    -- ['committer-tz'] = '+0200',
    -- summary = 'Create README.md',
    -- filename = 'README.md',
    local hash = blame.hash:sub(1, 7)
    -- -- Try to get only the first name of the author.
    -- -- The pattern matches from start everything that is not a space and
    -- -- removes everything from the space onward.
    -- local author = blame.author:gsub('^([^%s]*).*', '%1')
    -- local summary = blame.summary:sub(1, 30)
    return string.format('%s %s (%s) %s', hash, blame.author, blame.date, blame.summary)
  end,
})
