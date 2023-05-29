-- :h statusline for options

local function getlines()
  return [[%l/%L:%v]]
end

local function getfile()
  return [[%f%m%r%h%w]]
end

local function customModes()
  local current_mode = vim.api.nvim_get_mode().mode
  local t = {
    ['n']     = 'NORMAL',
    ['no']    = 'O-PENDING',
    ['nov']   = 'O-PENDING',
    ['noV']   = 'O-PENDING',
    ['no\22'] = 'O-PENDING',
    ['niI']   = 'NORMAL',
    ['niR']   = 'NORMAL',
    ['niV']   = 'NORMAL',
    ['nt']    = 'NORMAL',
    ['ntT']   = 'NORMAL',
    ['v']     = 'VISUAL',
    ['vs']    = 'VISUAL',
    ['V']     = 'V-LINE',
    ['Vs']    = 'V-LINE',
    ['\22']   = 'V-BLCK',
    ['\22s']  = 'V-BLCK',
    ['s']     = 'SELECT',
    ['S']     = 'S-LINE',
    ['\19']   = 'S-BLCK',
    ['i']     = 'INSERT',
    ['ic']    = 'INSERT',
    ['ix']    = 'INSERT',
    ['R']     = 'REPLCE',
    ['Rc']    = 'REPLCE',
    ['Rx']    = 'REPLCE',
    ['Rv']    = 'V-REPLCE',
    ['Rvc']   = 'V-REPLCE',
    ['Rvx']   = 'V-REPLCE',
    ['c']     = 'COMMND',
    ['cv']    = 'EX',
    ['ce']    = 'EX',
    ['r']     = 'REPLCE',
    ['rm']    = 'MORE',
    ['r?']    = 'CONFIRM',
    ['!']     = 'SHELL',
    ['t']     = 'TERMINAL',
  }

  return t[current_mode] or current_mode
end

local function formatLspProgress()
  -- Ta fazendo sumir a tela inicial do vim! )=
  -- A função formatLspProgress parece ser a culpada,
  -- mais especificamente a chamada pra require('lspconfig.util')
  -- Mais especificamente, o lspconfig.util.get_config_by_ft chama
  -- o require('lspconfig.util'), e é esse util que tá fazendo
  -- sumir a tela inicial do vim

  -- local buf_clients = {}

  -- local lspconfig_ok, lspconfig_util = pcall(require, 'lspconfig.util')
  -- if lspconfig_ok then
  --   -- Hopefully returns a table (list) with all the configured
  --   -- servers for this buffer.
  --   -- The standard get_active_clients returns empty list even
  --   -- when that filetype had a language server configured but
  --   -- it has stopped.
  --   -- The reason for this is that I want to write LSP Off only
  --   -- when there is at least one configured server for that
  --   -- filetype, but none active, and an empty string when
  --   -- there are no configured language servers for that filetype.
  --   -- I hope this works!
  --   buf_clients = lspconfig_util.get_config_by_ft(vim.bo.filetype)
  -- else
  --   buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
  -- end

  -- local p = require('lsp-progress').progress()
  -- if p == '' then p = 'LSP Off' end
  -- return p

  -- Chamar a função vim.lsp.get_active_clients
  -- também está fazendo sumir a tela inicial do vim! ):
  -- A guarda a seguir é pra não chamá-la quando
  -- abrimos o vim sem nenhum arquivo, ou seja,
  -- pra manter a tela inicial.
  if vim.bo.filetype == '' then return '' end

  local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })

  if #buf_clients == 0 then return '' end

  local s = ''
  for _, client in pairs(buf_clients) do
    s = client.name .. ', ' .. s
  end

  s = s:gsub(', $', '')

  return s
end

local function setup()
  require('lualine').setup({
    options = {
      globalstatus = true,
      icons_enabled = false,
      -- theme = 'everforest',
      theme = require('plugins.modified-everforest-theme'),
      -- theme = 'tokyonight',
      -- theme = 'catppuccin',
      component_separators = { '', '' },
      section_separators = { '', '' },
      disabled_filetypes = {},
    },
    sections = { -- sections of current buffer
      -- lualine_a = { 'mode' },
      lualine_a = { customModes },
      lualine_b = { getfile },
      lualine_c = { '' },
      lualine_x = { 'diff', formatLspProgress, },
      lualine_y = { 'filetype' },
      lualine_z = { getlines },
    },
    inactive_sections = { -- sections of other buffers
      lualine_a = {},
      lualine_b = {},
      lualine_c = { getfile },
      lualine_x = { getlines },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {}, -- tabline is the line at the top
    extensions = {},
  })
end

local function setColors()
  vim.cmd([[
  hi lualine_x_diff_added_command  guifg=#00af00
  hi lualine_x_diff_added_inactive guifg=#00af00
  hi lualine_x_diff_added_insert   guifg=#00af00
  hi lualine_x_diff_added_normal   guifg=#00af00
  hi lualine_x_diff_added_replace  guifg=#00af00
  hi lualine_x_diff_added_terminal guifg=#00af00
  hi lualine_x_diff_added_visual   guifg=#00af00

  hi lualine_x_diff_modified_command  guifg=#c39f00
  hi lualine_x_diff_modified_inactive guifg=#c39f00
  hi lualine_x_diff_modified_insert   guifg=#c39f00
  hi lualine_x_diff_modified_normal   guifg=#c39f00
  hi lualine_x_diff_modified_replace  guifg=#c39f00
  hi lualine_x_diff_modified_terminal guifg=#c39f00
  hi lualine_x_diff_modified_visual   guifg=#c39f00

  hi lualine_x_diff_removed_command  guifg=#ec2929
  hi lualine_x_diff_removed_inactive guifg=#ec2929
  hi lualine_x_diff_removed_insert   guifg=#ec2929
  hi lualine_x_diff_removed_normal   guifg=#ec2929
  hi lualine_x_diff_removed_replace  guifg=#ec2929
  hi lualine_x_diff_removed_terminal guifg=#ec2929
  hi lualine_x_diff_removed_visual   guifg=#ec2929
  ]])
end

return {
  setup = setup,
  setColors = setColors,
}
