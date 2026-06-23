return {
	'stevearc/overseer.nvim',
	cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerRunCmd', 'OverseerQuickAction' },
	keys = {
		{ '<leader>vt', '<cmd>OverseerRun<cr>', desc = 'Tasks: run (incl. .vscode/tasks.json)' },
		{ '<leader>vo', '<cmd>OverseerToggle<cr>', desc = 'Tasks: toggle output' },
		{ '<leader>vc', '<cmd>OverseerRunCmd<cr>', desc = 'Tasks: run shell command' },
		{ '<leader>va', '<cmd>OverseerQuickAction<cr>', desc = 'Tasks: quick action' },
	},
	opts = {
		-- The built-in `vscode` template reads `.vscode/tasks.json` from the project
		-- root, so the monorepo's existing task definitions show up in OverseerRun.
		templates = { 'builtin', 'vscode' },
	},
}
