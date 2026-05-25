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
			-- LSP keymaps, set per-buffer whenever any server attaches. Registered
			-- first and independently of the server configs below, so a failure
			-- while wiring up one server can never leave these (incl. code actions)
			-- unbound. This is the recommended nvim 0.11+ pattern.
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
					-- code actions also apply to a visual range, so bind both modes
					vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, opts)
				end,
			})

			-- Apply nvim-cmp capabilities to every server (incl. gopls/gdscript)
			-- via the wildcard config introduced in nvim 0.11.
			vim.lsp.config('*', {
				capabilities = require('cmp_nvim_lsp').default_capabilities(),
			})

			vim.lsp.config('gdscript', {})
			vim.lsp.enable('gdscript')

			-- go.nvim supplies gopls settings; guard it so a load/setup failure
			-- here can't abort the rest of the LSP configuration below.
			local ok, go_lsp = pcall(require, 'go.lsp')
			if ok then
				local go_cfg = go_lsp.config()
				go_cfg.settings.gopls.gofumpt = true
				vim.lsp.config('gopls', go_cfg)
			else
				vim.notify('go.nvim not available; gopls using defaults', vim.log.levels.WARN)
			end

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
		end,
	},
}
