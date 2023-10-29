local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
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

		  -- Snippets
		  'L3MON4D3/LuaSnip',
		  'rafamadriz/friendly-snippets',
	  }
	},

	{'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
	{'nvim-treesitter/playground'},
	{'theprimeagen/harpoon'},
	{'mbbill/undotree'},
	{'tpope/vim-fugitive'},
	{'kyazdani42/nvim-web-devicons'},
	{'ThePrimeagen/git-worktree.nvim'},
	{'marko-cerovac/material.nvim'},
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
},nil)

-- local ensure_packer = function()
	-- local fn = vim.fn
	-- local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	-- if fn.empty(fn.glob(install_path)) > 0 then
		-- fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		-- vim.cmd [[packadd packer.nvim]]
		-- return true
	-- end
	-- return false
-- end


-- local packer_bootstrap = ensure_packer()

-- return require('lazy').setup(
	-- -- packer auto managing
	-- use('wbthomason/packer.nvim'),
-- 
	-- use {
	  -- 'VonHeikemen/lsp-zero.nvim',
	  -- requires = {
		  -- -- LSP Support
		  -- {'neovim/nvim-lspconfig'},
		  -- {'williamboman/mason.nvim'},
		  -- {'williamboman/mason-lspconfig.nvim'},
-- 
		  -- -- Autocompletion
		  -- {'hrsh7th/nvim-cmp'},
		  -- {'hrsh7th/cmp-buffer'},
		  -- {'hrsh7th/cmp-path'},
		  -- {'saadparwaiz1/cmp_luasnip'},
		  -- {'hrsh7th/cmp-nvim-lsp'},
		  -- {'hrsh7th/cmp-nvim-lua'},
		  -- {'hrsh7th/cmp-vsnip'},
		  -- {'hrsh7th/cmp-cmdline'},
		  -- {'hrsh7th/cmp-path'},
-- 
		  -- -- Snippets
		  -- {'L3MON4D3/LuaSnip'},
		  -- {'rafamadriz/friendly-snippets'},
	  -- }
	-- }
-- 
	-- use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
	-- use('nvim-treesitter/playground')
	-- use('theprimeagen/harpoon')
	-- use('mbbill/undotree')
	-- use('tpope/vim-fugitive')
-- 
	-- use('kyazdani42/nvim-web-devicons')
	-- use('ThePrimeagen/git-worktree.nvim')
	-- use('marko-cerovac/material.nvim')
-- 
	-- use('lewis6991/gitsigns.nvim')
-- 
	-- use	{
	  -- 'nvim-telescope/telescope.nvim',
	  -- requires = {
		  -- {'nvim-lua/popup.nvim'},
		  -- {'nvim-lua/plenary.nvim'},
		  -- {'nvim-telescope/telescope-fzy-native.nvim'},
	  -- }
    	-- }
	-- use('nvim-telescope/telescope-media-files.nvim')
	-- use('folke/zen-mode.nvim')
-- 
	-- use({
	  -- 'aserowy/tmux.nvim',
	  -- config = function()
			-- require('tmux').setup({
				-- copy_sync = {
					-- -- enables copy sync
				-- },
				-- navigation = {
					-- enable_default_keybindings = false,
				-- },
				-- resize = {
					-- enable_default_keybindings = false,
				-- }
			-- })
	  -- end
	-- })
-- 
	-- if packer_bootstrap then
		-- require('packer').sync()
	-- end
-- end)

