return function()
  local diagnostics_amount = #(vim.diagnostic.get(0))

  if diagnostics_amount == 0 then
    return ''
  end

  return 'diagnostics: '..diagnostics_amount
end
