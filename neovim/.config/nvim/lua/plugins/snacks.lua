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
		},
		keys = {
			{ '<leader>gg', function() require('snacks').lazygit() end,              desc = 'Lazygit' },
			{ '<leader>gl', function() require('snacks').lazygit.log_file() end,   desc = 'Lazygit: file log' },
			{ '<leader>gL', function() require('snacks').lazygit.log() end,        desc = 'Lazygit: repo log' },
			{ '<leader>fe', function() require('snacks').explorer() end,              desc = 'File explorer' },
			{ '<leader>fn', function() require('snacks').notifier.show_history() end, desc = 'Notification history' },
			{ '<leader>wn', function() require('snacks').words.jump(1, true) end,     desc = 'Next word reference', mode = { 'n', 'x', 'o' } },
			{ '<leader>wp', function() require('snacks').words.jump(-1, true) end,    desc = 'Prev word reference', mode = { 'n', 'x', 'o' } },
		},
	},
}
