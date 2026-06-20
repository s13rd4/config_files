return {
	-- Consolidates several standalone plugins into the mini.nvim collection:
	--   mini.comment  -> replaces numToStr/Comment.nvim (gc / gcc mappings)
	--   mini.surround -> replaces kylechui/nvim-surround
	--   mini.ai       -> richer a/i text objects (functions, classes, args via
	--                    treesitter, plus brackets/quotes/tags out of the box)
	'nvim-mini/mini.nvim',
	version = false,
	event = 'VeryLazy',
	dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
	config = function()
		require('mini.comment').setup()
		require('mini.surround').setup()

		-- mini.ai owns function/class/argument text objects (via the treesitter
		-- queries supplied by nvim-treesitter-textobjects), so tree-sitter.lua no
		-- longer binds af/if/ac/ic/aa/ia itself. Use af/if, ac/ic, aa/ia here.
		local ai = require 'mini.ai'
		ai.setup {
			custom_textobjects = {
				f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
				c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
				a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
			},
		}
	end,
}
