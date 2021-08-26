return {
	-- packer auto managing
	{ "wbthomason/packer.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "kabouzeid/nvim-lspinstall" },
    { "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate"
    },
	{ "marko-cerovac/material.nvim" }
}
