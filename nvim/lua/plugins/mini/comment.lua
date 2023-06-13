-- The mini.comment plugin does not have comment blocks,
-- but it also comments weirdly when language has many comment syntaxes.
-- It is using /* */ in c files, buf // in go.
-- Does it matter? Probably not, but since it is lazy loaded on keys,
-- having both mini.comment and Comment.nvim also is probably ok. But weird.

require('mini.comment').setup({
  options = {
    ignore_blank_line = true,
  },

  mappings = {
    -- At some point I had both Comment.nvim and mini.comment, I used
    -- mini.comment exclusively for the text object. It was being setup
    -- with mappings to comment and comment_line disabled and as a dependency
    -- to Comment.nvim in the lazy plugin spec, like this:
    -- dependencies = { 'echasnovski/mini.comment', config = function() require('plugins.mini.comment') end, version = false, },
    -- comment = '',
    -- comment_line = '',

    -- I installed this plugin in place of
    -- Comment.nvim solely because of this.
    textobject = 'gc',
  }
})
