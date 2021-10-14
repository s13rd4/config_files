return {
	-- packer auto managing
	{"wbthomason/packer.nvim"},
	{"neovim/nvim-lspconfig"},
	{"kabouzeid/nvim-lspinstall"},
    {"nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate"
    },
	{"hrsh7th/nvim-cmp",
	  requires = {
		"hrsh7th/vim-vsnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/cmp-nvim-lsp",
	  }
	},
	{'kyazdani42/nvim-web-devicons'},
	{'nvim-telescope/telescope.nvim',
	  requires = {
		'nvim-lua/popup.nvim',
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-fzy-native.nvim'
	  }
    },
	{'tpope/vim-fugitive'},
	{'lewis6991/gitsigns.nvim',
	  requires = {
		'nvim-lua/plenary.nvim'
	  },
	  config = function()
		  require('gitsigns').setup()
	  end
	},
	{"marko-cerovac/material.nvim"},
	{"aserowy/tmux.nvim",
	  config = function()
			require("tmux").setup({
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
