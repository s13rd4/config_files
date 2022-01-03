require('material').setup({

	contrast = true, 
	borders = true, 

	popup_menu = "colorful",

	italics = {
		comments = false, 
		keywords = false, 
		functions = false, 
		strings = false, 
		variables = false 
	},

	contrast_windows = { 
		"terminal", 
		"packer", 
		"qf" 
	},

	text_contrast = {
		lighter = true, 
		darker = true 
	},

	disable = {
		background = false, 
		term_colors = false, 
		eob_lines = false 
	}
})
