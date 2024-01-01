return function()
  local clients_amount = #(vim.lsp.get_active_clients({ bufnr = 0 }))
  if clients_amount <= 0 then
    return ''
  end

  local diagnostics_amount = #(vim.diagnostic.get(0))

  if diagnostics_amount == 0 then
    return ''
  end

  return 'diagnostics: '..diagnostics_amount
end
