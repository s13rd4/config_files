return {
	{
		'L3MON4D3/LuaSnip',
		lazy = false,
		dependencies = {
			'rafamadriz/friendly-snippets',
			'saadparwaiz1/cmp_luasnip',
		},
		build = 'make install_jsregexp',
		config = function()
			require('luasnip.loaders.from_vscode').lazy_load()
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		lazy = false,
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-cmdline',
			'petertriho/cmp-git',
			'onsails/lspkind-nvim',
		},
		config = function()
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			cmp.setup {
				window = {
					documentation = cmp.config.window.bordered(),
					completion = cmp.config.window.bordered(),
				},
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm { select = true },
					-- Tab/S-Tab: move through the completion menu, otherwise
					-- expand/jump through snippet placeholders (LuaSnip).
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = cmp.config.sources({
					-- group_index 0 lets lazydev shadow the LSP source for require paths
					{ name = 'lazydev', group_index = 0 },
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				}, {
					{ name = 'buffer' },
				}),
			}

			-- Set configuration for specific filetype.
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				}, {
					{ name = 'buffer' },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' },
				}, {
					{ name = 'cmdline' },
				}),
			})
		end,
	},
}
