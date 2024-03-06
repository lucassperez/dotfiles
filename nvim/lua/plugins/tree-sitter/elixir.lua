vim.treesitter.language.register('heex', 'elixir')
vim.treesitter.language.register('elixir', 'elixir')

-- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
-- parser_config.elixir = {
--   install_info = {
--     url = '~/sources/tree-sitter-elixir', -- local path or git repo
--     files = { 'src/parser.c' },
--     branch = 'main',
--   },
--   -- filetype = 'zu', -- if filetype does not agrees with parser name
--   -- filetype_to_parsename = {'bar', 'baz'} -- additional filetypes that use this parser
-- }
