return {
	-- Consolidates several standalone plugins into the mini.nvim collection:
	--   mini.comment  -> replaces numToStr/Comment.nvim (gc / gcc mappings)
	--   mini.surround -> replaces kylechui/nvim-surround
	--   mini.ai       -> richer a/i text objects (functions, args, etc.)
	'nvim-mini/mini.nvim',
	version = false,
	event = 'VeryLazy',
	config = function()
		require('mini.comment').setup()
		require('mini.surround').setup()
		require('mini.ai').setup()
	end,
}
