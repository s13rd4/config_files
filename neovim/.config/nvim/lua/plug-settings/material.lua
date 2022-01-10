require('material').setup({

	contrast = {
		sidebars = false,
		popup_menu = false
	},

	italics = {
		comments = false, 
		keywords = false, 
		functions = false, 
		strings = false, 
		variables = false 
	},

	contrast_filetypes = { 
		"terminal", 
		"packer", 
		"qf" 
	},

	high_visibility = {
		lighter = true, 
		darker = true 
	},

	disable = {
		background = false, 
		term_colors = false, 
		eob_lines = false 
	}
})
