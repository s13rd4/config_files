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
		opts = {
			auto_intall = true,
		},
		config = function()
			require('mason-lspconfig').setup {
				ensure_installed = {
					'lua_ls',
					'gopls',
					'pyright',
					'ts_ls',
				},
			}
		end,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'j-hui/fidget.nvim', opts = {} },
		},
		lazy = false,
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			vim.lsp.config('gdscript',{})
			vim.lsp.enable('gdscript')

			local go_cfg = require('go.lsp').config()
			go_cfg.settings.gopls.gofumpt = true
			vim.lsp.config('gopls',go_cfg)

			vim.lsp.config('lua_ls',{
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = {
							callSnippet = 'Replace',
						},
						-- suppress vim error
						diagnostics = {
							globals = { 'vim' },
						},
					},
				},
			})

			vim.lsp.config('pyright',{
				capabilities = capabilities,
				settings = {
					python = {},
					pyright = {},
				}
			})

			vim.lsp.config('yamlls',{
				capabilities = capabilities,
				settings = {
					yaml = {
						schemas = {
						},
						format = {
							enable = false,
						},
						validate = true,
						completion = true
					}
				}
			})
			vim.lsp.config('tl_ls',{
			})

			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
			vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
		end,
	},
}
