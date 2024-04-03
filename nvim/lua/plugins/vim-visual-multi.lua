return {
  keys = '<C-m>',
  init = function()
    vim.g.VM_maps = {
      ['Find Under'] = '<C-m>',
      ['Find Subword Under'] = '<C-m>',
      ['Exit'] = '<C-c>',
    }
  end,
}
