return {
	{
		'mfussenegger/nvim-dap',
		config = function()
			local dap = require 'dap'

			vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP: continue' })
			vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'DAP: step over' })
			vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'DAP: step into' })
			vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'DAP: step out' })
			vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: toggle breakpoint' })
			vim.keymap.set('n', '<leader>dB', function()
				dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
			end, { desc = 'DAP: conditional breakpoint' })
			vim.keymap.set('n', '<leader>dl', function()
				dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
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
			local dap = require 'dap'
			local dapui = require 'dapui'

			dapui.setup {
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
			}

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
	{
		'mfussenegger/nvim-dap-python',
		dependencies = { 'mfussenegger/nvim-dap' },
		ft = 'python',
		config = function()
			local penv = require 'python_env'
			local dap = require 'dap'

			-- Adapter default interpreter (debugpy host). Per-package interpreters
			-- come from each configuration's `pythonPath` below, not this static
			-- value -- this is only the fallback when a config omits pythonPath.
			require('dap-python').setup(penv.interpreter(0) or 'python3')

			-- Custom configurations that resolve the interpreter per active buffer,
			-- so debugging follows the monorepo package you're in. `envFile` points
			-- debugpy at the package's python.envFile so its PYTHONPATH is applied.
			dap.configurations.python = dap.configurations.python or {}
			local function pythonPath()
				return penv.interpreter(0) or 'python3'
			end
			local function envFile()
				return penv.env_file(0) or nil
			end
			vim.list_extend(dap.configurations.python, {
				{
					type = 'python',
					request = 'launch',
					name = 'Launch file (package venv)',
					program = '${file}',
					pythonPath = pythonPath,
					envFile = envFile,
					console = 'integratedTerminal',
				},
				{
					type = 'python',
					request = 'launch',
					name = 'Launch module (package venv)',
					module = function()
						return vim.fn.input('Module: ')
					end,
					pythonPath = pythonPath,
					envFile = envFile,
					console = 'integratedTerminal',
				},
			})

			-- Import debug configs from the monorepo's .vscode/launch.json AND the
			-- root .code-workspace `launch` block. Resolve the launch.json relative
			-- to the current buffer's package (default cwd is wrong in a monorepo).
			-- Guarded so a missing/malformed file never aborts setup.
			pcall(function()
				local vscode = require 'dap.ext.vscode'
				local root = penv.package_root(0)
				local launch_json = root and (root .. '/.vscode/launch.json')
				vscode.load_launchjs(launch_json, { debugpy = { 'python' } })

				-- Workspace-file launch configs aren't a launch.json, so feed them
				-- to dap directly rather than via load_launchjs.
				local ws = penv.read_workspace(0)
				local configs = ws and ws.launch and ws.launch.configurations
				if type(configs) == 'table' then
					for _, cfg in ipairs(configs) do
						if cfg.type == 'python' or cfg.type == 'debugpy' then
							cfg.type = 'python'
							dap.configurations.python[#dap.configurations.python + 1] = cfg
						end
					end
				end
			end)

			vim.keymap.set('n', '<leader>dp', function()
				require('dap-python').test_method()
			end, { desc = 'DAP: debug python test method' })
		end,
	},
}
