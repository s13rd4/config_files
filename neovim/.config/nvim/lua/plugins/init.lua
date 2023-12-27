return {
--	{
--	  'VonHeikemen/lsp-zero.nvim',
--	  branch = 'v3.x',
--	  dependencies = {
--		  -- Autocompletion
--		  'hrsh7th/nvim-cmp',
--		  'hrsh7th/cmp-buffer',
--		  'hrsh7th/cmp-path',
--		  'saadparwaiz1/cmp_luasnip',
--		  'hrsh7th/cmp-nvim-lsp',
--		  'hrsh7th/cmp-nvim-lua',
--		  'hrsh7th/cmp-vsnip',
--		  'hrsh7th/cmp-cmdline',
--		  'hrsh7th/cmp-path',
--		  'petertriho/cmp-git',
--
--	  }
--	},
	{
		"folke/neodev.nvim",
		opts = {}
	},
	{
		'L3MON4D3/LuaSnip',
		version = "v2.*",
		build = "make install_jsregexp"
	},
	{'rafamadriz/friendly-snippets'},
	{'theprimeagen/harpoon'},
}
