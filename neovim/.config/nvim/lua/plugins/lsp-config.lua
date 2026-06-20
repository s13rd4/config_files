return {
	{
		-- declared once; lazy runs require('mason').setup(opts) automatically
		'mason-org/mason.nvim',
		lazy = false,
		opts = {},
	},
	{
		'mason-org/mason-lspconfig.nvim',
		dependencies = { 'mason-org/mason.nvim' },
		lazy = false,
		-- mason-lspconfig 2.0: `automatic_enable` (default true) runs vim.lsp.enable()
		-- for every installed server, so ensure_installed servers are wired up here.
		opts = {
			ensure_installed = {
				'lua_ls',
				'gopls',
				'pyright',
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
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
					end
					map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
					map('n', '<leader>gd', vim.lsp.buf.definition, 'Go to definition')
					map('n', '<leader>gr', vim.lsp.buf.references, 'List references')
					map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
					-- code actions also apply to a visual range, so bind both modes
					map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
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
