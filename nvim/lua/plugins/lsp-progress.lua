require('lsp-progress').setup({
  format = function()
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if #buf_clients == 0 then return 'LSP Off' end

    local s = ''
    for _, client in pairs(buf_clients) do
      s = client.name .. ', ' .. s
    end

    s = s:gsub(', $', '')

    return s
  end,
})
