return {
	'nvimtools/none-ls.nvim',
	config = function()
		local null_ls = require 'null-ls'
		local penv = require 'python_env'
		null_ls.setup {
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.golangci_lint,
				-- mypy is the monorepo's type checker. Run it against each package's
				-- interpreter (resolved from .vscode/settings.json) so it sees the
				-- right site-packages, and from the package root so it finds the
				-- package's mypy config. Skip when no interpreter resolves.
				null_ls.builtins.diagnostics.mypy.with {
					runtime_condition = function(params)
						return penv.interpreter(params.bufnr) ~= nil
					end,
					cwd = function(params)
						return penv.package_root(params.bufnr) or vim.fs.dirname(params.bufname)
					end,
					extra_args = function(params)
						return {
							'--python-executable',
							penv.interpreter(params.bufnr) or 'python3',
							'--show-column-numbers',
							'--no-pretty',
							'--no-error-summary',
						}
					end,
				},
			},
		}

		vim.keymap.set('n', '<leader>fo', vim.lsp.buf.format, { desc = 'Format buffer' })
	end,
}
