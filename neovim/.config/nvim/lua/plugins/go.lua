return {
	{
		'ray-x/go.nvim',
		dependencies = { -- optional packages
			'ray-x/guihua.lua',
			'neovim/nvim-lspconfig',
			'nvim-treesitter/nvim-treesitter',
		},
		config = function()
			-- gopls is configured in lsp-config.lua via require('go.lsp').config(),
			-- so let go.nvim skip its own LSP setup to avoid a duplicate client.
			require('go').setup { lsp_cfg = false }
		end,
		event = { 'CmdlineEnter' },
		ft = { 'go', 'gomod' },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
}
