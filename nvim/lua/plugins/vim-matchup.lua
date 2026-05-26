vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.matchup_matchparen_offscreen = {}

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function(args)
    local max_lines = 5000
    local bufnr = args.buf

    if
      vim.bo[bufnr].filetype == 'ruby'
      and vim.api.nvim_buf_get_name(bufnr):match('_spec%.rb$')
    then
      max_lines = 2500
    end

    local ok, line_count = pcall(vim.api.nvim_buf_line_count, args.buf)
    if not ok then return end

    if line_count > max_lines then
      -- Disable only for current buffer
      vim.b[bufnr].matchup_matchparen_enabled = 0
    end
  end,
})
