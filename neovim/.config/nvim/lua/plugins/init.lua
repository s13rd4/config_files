return {
	{
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  dependencies = {
		  -- LSP Support
		  'neovim/nvim-lspconfig',
		  'williamboman/mason.nvim',
		  'williamboman/mason-lspconfig.nvim',

		  -- Autocompletion
		  'hrsh7th/nvim-cmp',
		  'hrsh7th/cmp-buffer',
		  'hrsh7th/cmp-path',
		  'saadparwaiz1/cmp_luasnip',
		  'hrsh7th/cmp-nvim-lsp',
		  'hrsh7th/cmp-nvim-lua',
		  'hrsh7th/cmp-vsnip',
		  'hrsh7th/cmp-cmdline',
		  'hrsh7th/cmp-path',
		  'petertriho/cmp-git',

	  }
	},
	{
		'L3MON4D3/LuaSnip',
		version = "v2.*",
		build = "make install_jsregexp"
	},
	{'rafamadriz/friendly-snippets'},
	{'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
	{'nvim-treesitter/playground'},
	{'theprimeagen/harpoon'},
	{'mbbill/undotree'},
	{'tpope/vim-fugitive'},
	{'kyazdani42/nvim-web-devicons'},
	{'ThePrimeagen/git-worktree.nvim'},
	{'lewis6991/gitsigns.nvim'},
	{
	  'nvim-telescope/telescope.nvim',
	  dependencies = {
		  'nvim-lua/popup.nvim',
		  'nvim-lua/plenary.nvim',
		  'nvim-telescope/telescope-fzy-native.nvim',
	  }
	},
	{'nvim-telescope/telescope-media-files.nvim'},
	{'folke/zen-mode.nvim'},
	{
	  'aserowy/tmux.nvim',
	  config = function()
			require('tmux').setup({
				copy_sync = {
					-- enables copy sync
				},
				navigation = {
					enable_default_keybindings = false,
				},
				resize = {
					enable_default_keybindings = false,
				}
			})
	  end
	}
}