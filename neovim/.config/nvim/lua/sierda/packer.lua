local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	-- packer auto managing
	use('wbthomason/packer.nvim')

	use {
	  'VonHeikemen/lsp-zero.nvim',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},
		  {'hrsh7th/cmp-vsnip'},
		  {'hrsh7th/cmp-cmdline'},
		  {'hrsh7th/cmp-path'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
	}

	use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')

	use('kyazdani42/nvim-web-devicons')
	use('ThePrimeagen/git-worktree.nvim')
	use('marko-cerovac/material.nvim')

	use('lewis6991/gitsigns.nvim')

	use	{
	  'nvim-telescope/telescope.nvim',
	  requires = {
		  {'nvim-lua/popup.nvim'},
		  {'nvim-lua/plenary.nvim'},
		  {'nvim-telescope/telescope-fzy-native.nvim'},
	  }
    	}
	use('nvim-telescope/telescope-media-files.nvim')

	use({
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
	})

	if packer_bootstrap then
	  require('packer').sync()
	end
end)
