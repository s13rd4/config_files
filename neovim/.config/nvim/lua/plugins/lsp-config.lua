return {
	{
		'mason-org/mason.nvim',
		lazy = false,
		config = function()
			require('mason').setup()
		end,
	},
	{
		'mason-org/mason-lspconfig.nvim',
		dependencies = {
			{ 'mason-org/mason.nvim', opts = {} },
		},
		lazy = false,
		-- mason-lspconfig 2.0: `automatic_enable` (default true) runs vim.lsp.enable()
		-- for every installed server, so ensure_installed servers are wired up here.
		opts = {
			ensure_installed = {
				'lua_ls',
				'gopls',
				'pyright',
				'ts_ls',
				'yamlls',
				'jsonls',
			},
			automatic_enable = true,
		},
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'j-hui/fidget.nvim', opts = {} },
			'b0o/schemastore.nvim', -- JSON/YAML schemas for jsonls + yamlls
		},
		lazy = false,
		config = function()
			-- Apply nvim-cmp capabilities to every server (incl. gopls/gdscript)
			-- via the wildcard config introduced in nvim 0.11.
			vim.lsp.config('*', {
				capabilities = require('cmp_nvim_lsp').default_capabilities(),
			})

			vim.lsp.config('gdscript', {})
			vim.lsp.enable('gdscript')

			local go_cfg = require('go.lsp').config()
			go_cfg.settings.gopls.gofumpt = true
			vim.lsp.config('gopls', go_cfg)

			vim.lsp.config('lua_ls', {
				settings = {
					Lua = {
						completion = {
							callSnippet = 'Replace',
						},
					},
				},
			})

			vim.lsp.config('pyright', {
				settings = {
					python = {},
					pyright = {},
				},
			})

			vim.lsp.config('jsonls', {
				settings = {
					json = {
						schemas = require('schemastore').json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config('yamlls', {
				settings = {
					yaml = {
						-- let the schemastore plugin provide schemas instead of
						-- yamlls' built-in store (avoids duplicate entries)
						schemaStore = { enable = false, url = '' },
						schemas = require('schemastore').yaml.schemas(),
						format = {
							enable = false,
						},
						validate = true,
						completion = true,
					},
				},
			})

			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
			vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
		end,
	},
}
