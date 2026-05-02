-- LspInfo to see log file location, but probably ~/.local/state/nvim/lsp.log
-- vim.lsp.set_log_level('debug')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Ver isso depois? https://github.com/ray-x/lsp_signature.nvim

local defaults = require('lsp.defaults')

require('plugins.fidget')
require('mason').setup()

local ensure_installed = {
  'lua_ls',
  'marksman',
}

local helpers = require('lsp.helpers')

local function install_ensured(seen)
  local missing = {}

  for _, lsp_name in pairs(ensure_installed) do
    if not seen[lsp_name] then
      table.insert(missing, lsp_name)
    end
  end

  if #missing == 0 then
    return
  end

  local all_packages = require('mason-registry').get_all_packages()
  for _, ensured in ipairs(missing) do
    for _, pkg in ipairs(all_packages) do
      local spec = pkg.spec
      local name

      if pkg.name == ensured then
        name = ensured
      else
        name = spec.neovim and spec.neovim.lspconfig
      end

      if name and name == ensured then
        if not pkg:is_installed() then
          print('Installing Mason package: ' .. ensured)
          pkg:install()
          helpers.setup_server(ensured)
        end

        break
      end
    end
  end
end

local installed_servers, seen = helpers.get_installed_servers()

install_ensured(seen)

for _, server_name in ipairs(installed_servers) do
  helpers.setup_server(server_name)
end

vim.lsp.document_color.enable(false)
-- https://www.reddit.com/r/neovim/comments/14ecf5o/semantic_highlights_messing_with_todo_comments/
-- https://github.com/stsewd/tree-sitter-comment/issues/22
vim.api.nvim_set_hl(0, '@lsp.type.comment', {})

vim.diagnostic.config({
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = 'cursor',
        focus = false
      })
    end,
  },
})

require('lsp.user_commands').create()
