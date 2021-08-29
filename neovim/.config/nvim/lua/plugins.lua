return {
	-- packer auto managing
	{ "wbthomason/packer.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "kabouzeid/nvim-lspinstall" },
    { "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate"
    },
	{ "bluz71/vim-moonfly-colors"},
	{ "marko-cerovac/material.nvim",
	  config = function()
		  vim.g.material_style = 'deep ocean'
		  vim.g.material_italic_comments = true
		  vim.g.material_italic_keywords = false
		  vim.g.material_italic_functions = false
		  vim.g.material_italic_variables = false
		  vim.g.material_contrast = true
		  vim.g.material_borders = true
		  vim.g.material_disable_background = false
		  require('material').set()
	  end
	}
}
