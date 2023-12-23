return {
	'folke/zen-mode.nvim',
	opts = {
		window = {
			width = 110,
			options = {
				number = true,
				relativenumber = true,
			}
		}
	},
	config = function()
		vim.keymap.set('n','<leader>zz',function()
			require('zen-mode').toggle()
			vim.wo.wrap = false
		end)
	end
}
