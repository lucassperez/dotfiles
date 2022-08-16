vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup({
	styles = {
		comments = {},
		conditionals = {},
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	integrations = {
		treesitter = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
		cmp = true,
		gitgutter = true,
		telescope = true,
		nvimtree = {
			enabled = true,
			show_root = true,
			transparent_panel = false,
		},
	},
})

vim.cmd [[colorscheme catppuccin]]
vim.cmd [[hi Normal guibg=NONE]]
vim.cmd [[hi CursorLine guibg=#3A3B3C]]
vim.cmd [[hi Comment guifg=#585B70]]
