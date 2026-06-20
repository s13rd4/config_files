return {
	{
		'mfussenegger/nvim-dap',
		config = function()
			local dap = require('dap')

			vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP: continue' })
			vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'DAP: step over' })
			vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'DAP: step into' })
			vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'DAP: step out' })
			vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: toggle breakpoint' })
			vim.keymap.set('n', '<leader>dB', function()
				dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
			end, { desc = 'DAP: conditional breakpoint' })
			vim.keymap.set('n', '<leader>dl', function()
				dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
			end, { desc = 'DAP: log point' })
			vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'DAP: open REPL' })
			vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'DAP: run to cursor' })

			vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
			vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
			vim.fn.sign_define('DapLogPoint', { text = '◎', texthl = 'DiagnosticInfo' })
			vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'DiffAdd' })
			vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DiagnosticError' })
		end,
	},
	{
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
		config = function()
			local dap = require('dap')
			local dapui = require('dapui')

			dapui.setup({
				icons = { expanded = '▾', collapsed = '▸', current_frame = '▶' },
				layouts = {
					{
						elements = {
							{ id = 'scopes', size = 0.4 },
							{ id = 'breakpoints', size = 0.2 },
							{ id = 'stacks', size = 0.2 },
							{ id = 'watches', size = 0.2 },
						},
						size = 40,
						position = 'left',
					},
					{
						elements = {
							{ id = 'repl', size = 0.5 },
							{ id = 'console', size = 0.5 },
						},
						size = 12,
						position = 'bottom',
					},
				},
			})

			dap.listeners.after.event_initialized['dapui_config'] = dapui.open
			dap.listeners.before.event_terminated['dapui_config'] = dapui.close
			dap.listeners.before.event_exited['dapui_config'] = dapui.close

			vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'DAP: toggle UI' })
			vim.keymap.set({ 'n', 'v' }, '<leader>de', dapui.eval, { desc = 'DAP: evaluate expression' })
		end,
	},
	{
		'theHamsta/nvim-dap-virtual-text',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
		opts = {
			commented = true,
		},
	},
}
