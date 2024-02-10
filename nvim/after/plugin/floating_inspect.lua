vim.api.nvim_create_user_command('FloatingInspect', function()
  FloatingInspect()
end, {})

function FloatingInspect()
  --[[ :Inspect
  Treesitter
    - @variable.lua links to @variable lua
    - @variable.member.lua links to @variable.member lua

  Semantic Tokens
    - @lsp.type.property.lua links to @property priority: 125

  Extmarks
    - RainbowDelimiterRed
    - MatchParenCur links to MatchParen vim-matchup

  Syntax
    - elixirBlock
    - elixirBlock
    - elixirId links to Type
  ]]

  --[[ =vim.inspect_pos()
    extmarks = { {
      col = 2,
      end_col = 3,
      end_row = 85,
      id = 871,
      ns = "",
      ns_id = 10,
      opts = {
        end_col = 3,
        end_right_gravity = false,
        end_row = 85,
        hl_eol = false,
        hl_group = "RainbowDelimiterRed",
        hl_group_link = "RainbowDelimiterRed",
        ns_id = 10,
        priority = 110,
        right_gravity = true
      },
      row = 85
    }, {
      col = 2,
      end_col = 3,
      end_row = 85,
      id = 268,
      ns = "vim-matchup",
      ns_id = 6,
      opts = {
        end_col = 3,
        end_right_gravity = false,
        end_row = 85,
        hl_eol = false,
        hl_group = "MatchParenCur",
        hl_group_link = "MatchParen",
        ns_id = 6,
        priority = 4096,
        right_gravity = true
      },
      row = 85
    } },
    semantic_tokens = { {
      col = 4,
      end_col = 10,
      end_row = 30,
      id = 2231,
      ns = "vim_lsp_semantic_tokens:1",
      ns_id = 19,
      opts = {
        end_col = 10,
        end_right_gravity = false,
        end_row = 30,
        hl_eol = false,
        hl_group = "@lsp.type.property.lua",
        hl_group_link = "@property",
        ns_id = 19,
        priority = 125,
        right_gravity = true
      },
      row = 30
    } },
  syntax = { {
    hl_group = "elixirBlock",
    hl_group_link = "elixirBlock"
  }, {
    hl_group = "elixirBlock",
    hl_group_link = "elixirBlock"
  }, {
    hl_group = "elixirId",
    hl_group_link = "elixirId"
  } },
  treesitter = { {
      capture = "variable",
      hl_group = "@variable.lua",
      hl_group_link = "@variable",
      lang = "lua",
      metadata = {}
    }, {
      capture = "variable.member",
      hl_group = "@variable.member.lua",
      hl_group_link = "@variable.member",
      lang = "lua",
      metadata = {}
    } }
  ]]

  local info = vim.inspect_pos()

  local text = {}
  local longest_string_size = 0

  if #info.syntax > 0 then
    table.insert(text, '')
    local title = '# Syntax'
    table.insert(text, title)
    if #title > longest_string_size then longest_string_size = #title end

    for _, sy in pairs(info.syntax) do
      local s = string.format('  - %s **links to** %s', sy.hl_group, sy.hl_group_link)

      if #s > longest_string_size then longest_string_size = #s end

      table.insert(text, s)
    end
  end

  if #info.treesitter > 0 then
    table.insert(text, '')
    local title = '# Treesitter'
    table.insert(text, title)
    if #title > longest_string_size then longest_string_size = #title end

    for _, ts in pairs(info.treesitter) do
      local s = string.format('  - %s **links to** %s _(lang: %s)_', ts.hl_group, ts.hl_group_link, ts.lang)

      if #s > longest_string_size then longest_string_size = #s end

      table.insert(text, s)
    end
  end

  if #info.semantic_tokens > 0 then
    table.insert(text, '')
    local title = '# Semantic Tokens'
    table.insert(text, title)
    if #title > longest_string_size then longest_string_size = #title end

    table.sort(info.semantic_tokens, function(st1, st2)
      return st1.opts.priority < st2.opts.priority
    end)

    for _, st in pairs(info.semantic_tokens) do
      local s = string.format(
        '  - %s **links to** %s _(priority: %d)_',
        st.opts.hl_group,
        st.opts.hl_group_link,
        st.opts.priority
      )

      if #s > longest_string_size then longest_string_size = #s end

      table.insert(text, s)
    end
  end

  if #info.extmarks > 0 then
    table.insert(text, '')
    local title = '# Extmarks'
    table.insert(text, title)
    if #title > longest_string_size then longest_string_size = #title end

    table.sort(info.extmarks, function(ext1, ext2)
      return ext1.opts.priority < ext2.opts.priority
    end)

    for _, ext in pairs(info.extmarks) do
      local s = string.format(
        '  - %s **links to** %s _(priority: %d)_',
        ext.opts.hl_group,
        ext.opts.hl_group_link,
        ext.opts.priority
      )

      if ext.ns and ext.ns ~= '' then s = s .. string.format(' _[ns: %s]_', ext.ns) end

      if #s > longest_string_size then longest_string_size = #s end

      table.insert(text, s)
    end
  end

  if #text == 0 then return end

  if text[1] == '' then table.remove(text, 1) end

  local longest_title = '# Semantic Tokens'
  if longest_string_size < #longest_title then longest_string_size = 1 + #longest_title end

  local config = {
    relative = 'cursor',
    width = longest_string_size,
    height = #text + 1,
    row = 0,
    col = 0,
    style = 'minimal',
    border = 'single',
    focusable = true,
    focus = true,
    focus_id = '_my_floating_inspect_focus_id_',
  }

  vim.lsp.util.open_floating_preview(text, 'markdown', config)
end
