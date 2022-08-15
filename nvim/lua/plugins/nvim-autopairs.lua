local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  -- ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
  ignored_next_char = "[%w%_]",
  enable_check_bracket_line = false,
  map_c_h = true,  -- Map the <C-h> key to delete a pair
  map_c_w = true, -- map <c-w> to delete a pair if possible
  map_cr = true,
  map_bs = true,
})

npairs.add_rules {
  -- Space inside parens
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%)') ~= nil
    end)
    :use_key(')'),
  Rule('{ ', ' }')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%}') ~= nil
    end)
    :use_key('}'),
  Rule('[ ', ' ]')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%]') ~= nil
    end)
    :use_key(']'),
}
