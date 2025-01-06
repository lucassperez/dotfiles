local luasnip = require('luasnip')
local types = require('luasnip.util.types')

require('plugins.luasnip.snippets')

-- Aparentemente, sair do modo de inserção
-- não dispara esse evento ):

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'LuasnipChoiceNodeEnter',
--   callback = function()
--     print('entrei')
--   end
-- })
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'LuasnipChoiceNodeLeave',
--   callback = function()
--     print('saí')
--   end
-- })

-- Unlinking has the effect of not being able to
-- jump to it anymore, but jumping has the effect
-- of jumping, which could be extremely annoying
-- if the next node is an insert node.

-- vim.api.nvim_create_autocmd('InsertLeavePre', {
--   callback = function()
--     if luasnip.choice_active() then
--       -- print('Choice ativo! Deslinkando')
--       -- luasnip.jump(1)
--       -- if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then luasnip.unlink_current() end
--       -- require('luasnip').unlink_current()
--       -- vim.cmd('doautocmd User LuasnipChoiceNodeLeave')
--     end
--   end
-- })

luasnip.config.set_config({
  history = true,
  enable_autosnippets = true,

  update_events = { 'TextChanged', 'TextChangedI' },
  region_check_events = { 'InsertLeave', 'InsertEnter' },
  delete_check_events = { 'InsertLeave', 'InsertEnter' },

  ext_opts = {
    [types.choiceNode] = {
      active = {
        -- Virtual text persists if I exit when it is visible
        virt_text = { { '«« Choice Node', 'Comment' } },
      },
    },
  },
})

-- Keymaps

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if luasnip.expandable() then
    luasnip.expand()
  elseif luasnip.locally_jumpable(1) then
    luasnip.jump(1)
  else
    local line = vim.api.nvim_get_current_line() -- Get the current line
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2] -- Get the cursor column (0-based)

    -- If between > and <, <C-j> makes this: >|< into this:
    -- >
    --   |
    -- <
    -- Not sure if this file is the place for this, but okay
    if
      cursor_col > 0
      and line:sub(cursor_col, cursor_col) == '>'
      and line:sub(cursor_col + 1, cursor_col + 1) == '<'
    then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR><CR><Up><Tab>', true, false, true), 'n', false)
    end
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if luasnip.choice_active() then luasnip.change_choice(1) end
end, { silent = true })
