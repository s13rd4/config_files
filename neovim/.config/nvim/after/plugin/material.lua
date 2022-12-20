require('material').setup({

	contrast = {
		terminal = true,
		floating_windows = true,
		sidebars = false,
		cursor_line = false,
		non_current_windows = false,
		filetypes = {
			"terminal",
			"packer"
		},
	},
	styles = {
		comments = {italic=true},
		strings = {},
		keywords = {bold=true},
		functions = {bold=true},
		variables = {},
		operators = {},
		types = {},
	},
	plugins = {
		"telescope",
		"nvim-web-devicons",
		"gitsigns",
		"nvim-cmp",
		"nvim-tree",
		"dap",
	},

	disable = {
		colored_cursor = false,
		border = false,
		background = false,
		term_colors = false,
		eob_lines = false
	},

	high_visibility = {
		lighter = true,
		darker = true
	},
	lualine_style = "default",
	async_loading = true,

    custom_colors = nil,

    custom_highlights = {},
})
