require('material').setup({

	contrast = {
		terminal = false,
		floating_windows = false,
		sidebars = false,
		cursor_line = false,
		non_current_windows = false,
		filetypes = {
			"qf",
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
	},

	disable = {
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
