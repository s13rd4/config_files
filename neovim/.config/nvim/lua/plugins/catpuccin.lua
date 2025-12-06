return {
	{
		'catppuccin/nvim',
		lazy = false,
		priority = 1000,
		name = 'catppuccin',
		opts = {
			flavour = 'mocha', -- latte, frappe, macchiato, mocha
			background = {
				light = 'latte',
				dark = 'mocha',
			},
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = false,
			dim_inactive = {
				enabled = false,
				shade = 'dark',
				percentage = 0.15,
			},
			styles = {
				comments = { 'italic' },
				functions = { 'bold' },
				keywords = { 'italic' },
				strings = {},
				variables = {},
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				neo_tree = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { 'italic' },
						hints = { 'italic' },
						warnings = { 'italic' },
						information = { 'italic' },
					},
					underlines = {
						errors = { 'underline' },
						hints = { 'underline' },
						warnings = { 'underline' },
						information = { 'underline' },
					},
				},
				treesitter = true,
				which_key = true,
			},
		},
		config = function(_, opts)
			require('catppuccin').setup(opts)
			vim.cmd [[colorscheme catppuccin]]
		end,
	}
}
