return {
	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		config = function(_, opts)
			require('snacks').setup(opts)
			-- ui_select = true inside opts tells snacks to override vim.ui.select,
			-- but in headless / early-init contexts the VimEnter hook may not have
			-- fired yet.  Set it explicitly so :checkhealth and any plugin that reads
			-- vim.ui.select at startup always sees the snacks implementation.
			vim.ui.select = require('snacks.picker').select
		end,
		opts = {
			bigfile = {
				-- disable heavy features above 1.5 MB
				size = 1.5 * 1024 * 1024,
			},
			notifier = {
				timeout = 3000,
				style = 'fancy',
			},
			picker = {
				ui_select = true,
				sources = {
					explorer = {
						hidden = true,
						ignored = false,
						exclude = {
							'*.uid',
							'server.pipe',
						},
					},
				},
			},
			words = {
				-- highlight all occurrences of the word under cursor
				enabled = true,
				debounce = 200,
			},
			lazygit = { enabled = true },
			statuscolumn = { enabled = true },
			quickfile = { enabled = true },
			-- indent guides (replaces indent-blankline.nvim)
			indent = { enabled = true },
			-- floating vim.ui.input (used by the git-worktree prompts)
			input = { enabled = true },
			-- start screen (replaces alpha-nvim); keeps the custom header
			dashboard = {
				enabled = true,
				preset = {
					header = [[
       ████ ██████           █████      ██
      ███████████             █████
      █████████ ███████████████████ ███   ███████████
     █████████  ███    █████████████ █████ ██████████████
    █████████ ██████████ █████████ █████ █████ ████ █████
  ███████████ ███    ███ █████████ █████ █████ ████ █████
 ██████  █████████████████████ ████ █████ █████ ████ ██████]],
				},
			},
		},
		keys = {
			-- Lazygit
			{
				'<leader>gg',
				function()
					require('snacks').lazygit()
				end,
				desc = 'Lazygit',
			},
			{
				'<leader>gl',
				function()
					require('snacks').lazygit.log_file()
				end,
				desc = 'Lazygit: file log',
			},
			{
				'<leader>gL',
				function()
					require('snacks').lazygit.log()
				end,
				desc = 'Lazygit: repo log',
			},
			-- File explorer (replaces neo-tree)
			{
				'<C-n>',
				function()
					require('snacks').explorer()
				end,
				desc = 'Toggle file explorer',
			},
			{
				'<leader>fe',
				function()
					require('snacks').explorer()
				end,
				desc = 'File explorer',
			},
			-- Pickers (replaces telescope)
			{
				'<leader>fd',
				function()
					require('snacks').picker.files { hidden = true }
				end,
				desc = 'Find files',
			},
			{
				'<leader>fr',
				function()
					require('snacks').picker.git_files()
				end,
				desc = 'Find git-tracked files',
			},
			{
				'<leader>fg',
				function()
					require('snacks').picker.grep()
				end,
				desc = 'Live grep',
			},
			{
				'<leader>fb',
				function()
					require('snacks').picker.buffers()
				end,
				desc = 'Find open buffers',
			},
			{
				'<leader>bf',
				function()
					require('snacks').picker.buffers()
				end,
				desc = 'Find open buffers',
			},
			{
				'<leader>fn',
				function()
					require('snacks').notifier.show_history()
				end,
				desc = 'Notification history',
			},
			-- Word references
			{
				'<leader>wn',
				function()
					require('snacks').words.jump(1, true)
				end,
				desc = 'Next word reference',
				mode = { 'n', 'x', 'o' },
			},
			{
				'<leader>wp',
				function()
					require('snacks').words.jump(-1, true)
				end,
				desc = 'Prev word reference',
				mode = { 'n', 'x', 'o' },
			},
		},
	},
}
