return {
	'nvim-neotest/neotest',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-neotest/nvim-nio',
		'nvim-treesitter/nvim-treesitter',
		'nvim-neotest/neotest-python',
		'mfussenegger/nvim-dap-python', -- enables "debug nearest test"
	},
	ft = 'python',
	config = function()
		local penv = require 'python_env'

		require('neotest').setup {
			adapters = {
				require 'neotest-python' {
					runner = 'pytest',
					-- per-package interpreter, resolved against the test file's buffer
					python = function()
						return penv.interpreter(0) or 'python3'
					end,
					dap = { justMyCode = false },
					args = { '--quiet' },
				},
			},
		}

		local neotest = require 'neotest'
		local function map(lhs, rhs, desc)
			vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
		end

		map('<leader>tt', function()
			neotest.run.run()
		end, 'Test: run nearest')
		map('<leader>tf', function()
			neotest.run.run(vim.fn.expand '%')
		end, 'Test: run file')
		map('<leader>tl', function()
			neotest.run.run_last()
		end, 'Test: run last')
		map('<leader>td', function()
			neotest.run.run { strategy = 'dap' }
		end, 'Test: debug nearest')
		map('<leader>tS', function()
			neotest.run.stop()
		end, 'Test: stop')
		map('<leader>ts', function()
			neotest.summary.toggle()
		end, 'Test: toggle summary')
		map('<leader>to', function()
			neotest.output.open { enter = true }
		end, 'Test: show output')
		map('<leader>tO', function()
			neotest.output_panel.toggle()
		end, 'Test: toggle output panel')
		map(']t', function()
			neotest.jump.next { status = 'failed' }
		end, 'Test: next failed')
		map('[t', function()
			neotest.jump.prev { status = 'failed' }
		end, 'Test: prev failed')
	end,
}
