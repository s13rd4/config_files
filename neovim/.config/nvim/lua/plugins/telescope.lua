return {
	{ 'nvim-telescope/telescope-media-files.nvim' },
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/popup.nvim',
			'nvim-lua/plenary.nvim',
			-- needs the C extension compiled, otherwise load_extension('fzf') errors
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			require('telescope').setup {
				pickers = {
					find_files = {
						hidden = true,
					},
					git_files = {
						hidden = true,
					},
				},
			}
			local builtin = require 'telescope.builtin'
			vim.keymap.set('n', '<leader>fd', builtin.find_files, { desc = 'Find files' })
			vim.keymap.set('n', '<leader>fr', builtin.git_files, { desc = 'Find git-tracked files' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
			vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find open buffers' })
			require('telescope').load_extension 'fzf'
		end,
	},
}
