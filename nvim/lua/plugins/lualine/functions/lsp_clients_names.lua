return function()
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

  -- get_active_clients is deprecated in neovim 0.11.0,
  -- should use get_clients

  -- local p = require('lsp-progress').progress()
  -- if p == '' then p = 'LSP Off' end
  -- return p

  -- Chamar a função vim.lsp.get_active_clients
  -- também está fazendo sumir a tela inicial do vim! ):
  -- A guarda a seguir é pra não chamá-la quando
  -- abrimos o vim sem nenhum arquivo, ou seja,
  -- pra manter a tela inicial.
  if vim.bo.filetype == '' then return '' end

  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })

  if #buf_clients == 0 then return '' end

  local s = ''
  for _, client in pairs(buf_clients) do
    s = client.name .. ', ' .. s
  end

  s = s:gsub(', $', '')

  return s
end
