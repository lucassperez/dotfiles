-- Example config in Lua
vim.g.tokyonight_transparent = true
vim.g.tokyonight_style = 'night'
-- vim.g.tokyonight_style = 'storm'
-- vim.g.tokyonight_style = 'night'
vim.g.tokyonight_italic_comments = false
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_transparent_sidebar = true

-- Change the "hint" color to the "orange" color, and make the "error" color bright red
-- vim.g.tokyonight_colors = { hint = 'orange', error = '#ff0000' }

-- Load the colorscheme
vim.cmd[[colorscheme tokyonight]]
