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
				'ruff',
				'yamlls',
				'jsonls',
			},
			automatic_enable = true,
		},
	},
	{
		-- Installs non-LSP tools (mypy, debugpy) declaratively so the dotfiles stay
		-- reproducible after a fresh Stow/clone. mason-lspconfig only handles LSP
		-- servers, so these go through mason-tool-installer instead.
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		dependencies = { 'mason-org/mason.nvim' },
		lazy = false,
		opts = {
			ensure_installed = {
				'mypy',
				'debugpy',
			},
		},
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'j-hui/fidget.nvim', opts = {} },
			'b0o/schemastore.nvim', -- JSON/YAML schemas for jsonls + yamlls
			-- Reads `.vscode/settings.json` / `.neoconf.json` and merges those keys
			-- into each server's `settings` (e.g. pyright's analysis.extraPaths).
			'folke/neoconf.nvim',
		},
		lazy = false,
		config = function()
			-- neoconf MUST initialize before any LSP is configured/enabled so its
			-- per-project settings merge is in place. Keep this the first line.
			require('neoconf').setup {}

			-- LSP keymaps, set per-buffer whenever any server attaches. Registered
			-- first and independently of the server configs below, so a failure
			-- while wiring up one server can never leave these (incl. code actions)
			-- unbound. This is the recommended nvim 0.11+ pattern.
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),
				callback = function(ev)
					-- Let pyright own hover/types; ruff only does lint + fixes +
					-- formatting, so silence its (less useful) hover responses.
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.name == 'ruff' then
						client.server_capabilities.hoverProvider = false
					end

					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
					end
					map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
					map('n', '<leader>gd', vim.lsp.buf.definition, 'Go to definition')
					map('n', '<leader>gr', vim.lsp.buf.references, 'List references')
					map('n', '<leader>gi', vim.lsp.buf.implementation, 'Go to implementation')
					map('n', '<leader>gy', vim.lsp.buf.type_definition, 'Type definition')
					map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')
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
			vim.lsp.enable 'gdscript'

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

			-- Pyright: one instance per package (root_markers stop at each package
			-- so distinct packages get distinct interpreters), with the interpreter
			-- resolved from the package's .vscode/settings.json. neoconf supplies
			-- analysis.extraPaths/typeCheckingMode from that file, but
			-- `defaultInterpreterPath` is a VSCode-extension concept pyright ignores,
			-- so we translate it to pyright's `python.pythonPath` here.
			vim.lsp.config('pyright', {
				root_markers = { '.vscode', 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
				before_init = function(_, config)
					-- pyright is launched when a python file is opened, so buffer 0 is
					-- the triggering file and resolves to this root's package.
					local ok, penv = pcall(require, 'python_env')
					if not ok then
						return
					end
					config.settings = config.settings or {}
					config.settings.python = config.settings.python or {}
					local interp = penv.interpreter(0)
					if interp then
						config.settings.python.pythonPath = interp
					end
					local extra = penv.extra_paths(0)
					if #extra > 0 then
						config.settings.python.analysis = config.settings.python.analysis or {}
						config.settings.python.analysis.extraPaths = extra
					end
				end,
			})

			-- Ruff language server (the rust `ruff server`, mason package `ruff`):
			-- linting, quick-fixes, organize-imports, and formatting as code actions.
			vim.lsp.config('ruff', {})

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
