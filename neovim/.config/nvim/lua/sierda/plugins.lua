vim.cmd [[packadd packer.nvim]]

return {
	-- packer auto managing
	{"wbthomason/packer.nvim"},
	{'nvim-lua/popup.nvim'},
	{'nvim-lua/plenary.nvim'},

	{"neovim/nvim-lspconfig"},
	{"williamboman/nvim-lsp-installer"},
	{"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate"
	},
	{"hrsh7th/nvim-cmp",
	  requires = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-path",
	  }
	},
	{'L3MON4D3/LuaSnip',
	requires = {
		'saadparwaiz1/cmp_luasnip'
		}
	},
	{'rafamadriz/friendly-snippets'},
	{'kyazdani42/nvim-web-devicons'},
	{'nvim-telescope/telescope.nvim',
	  requires = {
		'nvim-lua/popup.nvim',
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-fzy-native.nvim'
	  }
    },
	{'nvim-telescope/telescope-media-files.nvim'},
	{'tpope/vim-fugitive'},
	{'ThePrimeagen/git-worktree.nvim'},
	{"marko-cerovac/material.nvim"},
	{'lewis6991/gitsigns.nvim',
	  requires = {
		'nvim-lua/plenary.nvim'
	  }
	},
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
	},
	{"lervag/vimtex"}
}
