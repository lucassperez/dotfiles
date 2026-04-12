local v = vim.version()
if v.major == 0 and v.minor < 12 then
  return
end

require('vim._core.ui2').enable({})

-- Don't syntax highlight cmdline
-- It is hideous
---@diagnostic disable: duplicate-set-field
do
  local cmdline = require('vim._core.ui2.cmdline')
  local original_cmdline_show = cmdline.cmdline_show
  cmdline.cmdline_show = function(...)
    local original_parser = vim.treesitter.get_string_parser

    -- UI2 highlights ':' cmdline input with a temporary Tree-sitter string parser.
    -- Disable only that parser so we keep the pager buffer without cmdline colors.
    -- The following file has more implementation details:
    -- {runtime}/lua/vim/_core/ui2/cmdline.lua
    -- Function M.cmdline_show, line 94, eventually calls the helper set_text.
    -- This helper has the following elsif:
    -- elseif lines[1]:sub(1, 1) == ':' then
    --   local parser = vim.treesitter.get_string_parser(lines[1], 'vim')
    -- So we're highjacking the get_string_parser just during the cmdline_show,
    -- and then placing back the original vim.treesitter.get_string_parser.
    vim.treesitter.get_string_parser = function()
      return {
        parse = function() end,
        for_each_tree = function() end,
      }
    end
    local ok, result = pcall(original_cmdline_show, ...)
    vim.treesitter.get_string_parser = original_parser

    if not ok then
      error(result)
    end

    return result
  end
end
