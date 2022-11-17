local status_ok, telescope = pcall(require,"telescope")
if not status_ok then
	return
end

telescope.load_extension('media_files')

local actions = require('telescope.actions')

telescope.setup({
	defaults = {
		path_display = {"smart"},
		mappings = {
			i = {},
			n = {}
		},
	},
	pickers = {},
	extensions = {
		media_files = {
			filetypes = {'png','webp','jpg','jpeg'},
			find_cmd = "rg"
		}
	}
})
