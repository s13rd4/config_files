return {
	{ 'habamax/vim-godot' },
	{ 'skywind3000/asyncrun.vim' },
	{
		'Mathijs-Bakker/godotdev.nvim',
		dependencies = { 'mfussenegger/nvim-dap', 'rcarriga/nvim-dap-ui', 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('godotdev').setup({
				csharp = false,
			})
		end,
	},
	{ 'teatek/gdscript-extended-lsp.nvim', opts = { view_type = 'floating', picker = 'snacks' } },
}
