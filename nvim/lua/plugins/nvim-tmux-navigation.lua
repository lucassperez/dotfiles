--[[
christoomey/vim-tmux-navigator was giving me an issue that
when moving around LuaSnip's spots in snippets with C-j,
which is the mapping I chose, vim-tmux-navigator would
change me from nvim to another tmux pane. Sometimes.
I actually don't know the real steps to reproduce this.
But this didn't happen with neither tmux.nvim nor nvim-tmux-navigation.
I suspect that tmux.nvim was messing with my registers,
probably due to some weird setup I might have done,
so now I'm with this one.
]]
require('nvim-tmux-navigation').setup({
  disable_when_zoomed = false,
  keybindings = {
    left = '<C-h>',
    down = '<C-j>',
    up = '<C-k>',
    right = '<C-l>',
    last_active = '<C-\\>',
    next = '<C-Space>',
  },
})

-- Came back to old vim-tmux-navigator.
-- I think the standard mappings were somehow
-- messing up when in other modes that not only
-- the normal mode? I don't know. But I now mapped
-- them exclusively in normal mode.
-- The Lazy plugin spec I was using
-- for nvim-tmux-navigation is as follows:
-- {
--   'alexghergh/nvim-tmux-navigation',
--   keys = {
--     { '<C-h>', '<Cmd>NvimTmuxNavigateLeft<CR>' },
--     { '<C-j>', '<Cmd>NvimTmuxNavigateDown<CR>' },
--     { '<C-k>', '<Cmd>NvimTmuxNavigateUp<CR>' },
--     { '<C-l>', '<Cmd>NvimTmuxNavigateRight<CR>' },
--     { '<C-\\>', '<Cmd>NvimTmuxNavigateLastActive<CR>' },
--   },
--   config = function()
--     require('plugins.nvim-tmux-navigation')
--   end,
-- },
