return {
	'nvim-neo-tree/neo-tree.nvim',
	branch = 'v3.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'MunifTanjim/nui.nvim',
	},
	config = function()
		vim.keymap.set('n', '<C-n>', ':Neotree filesystem toggle left<CR>', { desc = 'Reveal file tree' })
		vim.keymap.set('n', '<leader>bf', ':Neotree buffers reveal float<CR>', { desc = 'Buffers (floating tree)' })
		require('neo-tree').setup({
			filesystem = {
				filtered_items = {
					visible = false,
					hide_gitignored = true,
					hide_dotfiles = true,
				}
			}
		})
	end,
}
