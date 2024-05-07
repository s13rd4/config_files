return {
	{
		'williamboman/mason.nvim',
		lazy = true,
		config = function()
			require('mason').setup()
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
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
			local lspconfig = require 'lspconfig'
			lspconfig.gopls.setup {
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			}
			lspconfig.lua_ls.setup {
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
			}
			lspconfig.pyright.setup {
				capabilities = capabilities,
				settings = {
					python = {},
					pyright = {},
				}
			}

			lspconfig.yamlls.setup {
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
			}

			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
			vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
		end,
	},
}
