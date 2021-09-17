return {
	-- packer auto managing
	{ "wbthomason/packer.nvim" },

	{ "neovim/nvim-lspconfig" },
	{ "kabouzeid/nvim-lspinstall" },
    { "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate"
    },
	{ "hrsh7th/nvim-cmp",
	  requires = {
		  "hrsh7th/vim-vsnip",
		  "hrsh7th/cmp-buffer",
		  "hrsh7th/cmp-vsnip",
		  "hrsh7th/cmp-nvim-lsp",
	  }
	},
	{ "marko-cerovac/material.nvim"}
}
