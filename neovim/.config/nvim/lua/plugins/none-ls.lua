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
					-- Run on save only: fewer mypy invocations on a big monorepo, fewer
					-- temp-file writes, and avoids spurious warnings on unsaved buffers.
					method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
					-- none-ls' mypy uses to_temp_file + --shadow-file; null-ls otherwise
					-- writes the `.null-ls_*` temp file next to the edited file (i.e. into
					-- the package). Park it under the cache dir instead -- safe because
					-- --shadow-file keeps the ORIGINAL path for module context.
					temp_dir = vim.fn.stdpath 'cache',
					runtime_condition = function(params)
						return penv.interpreter(params.bufnr) ~= nil
					end,
					cwd = function(params)
						return penv.package_root(params.bufnr) or vim.fs.dirname(params.bufname)
					end,
					-- mypy searches MYPYPATH (not PYTHONPATH); feed it the package's
					-- env-file import dirs so PYTHONPATH-only imports type-check.
					env = function(params)
						local run = penv.run_env(params.bufnr)
						return run.MYPYPATH and { MYPYPATH = run.MYPYPATH } or nil
					end,
					extra_args = function(params)
						return {
							'--python-executable',
							penv.interpreter(params.bufnr) or 'python3',
							-- don't litter the package with a .mypy_cache/ directory
							'--cache-dir',
							'/dev/null',
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
