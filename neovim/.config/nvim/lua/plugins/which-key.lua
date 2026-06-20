return {
	-- Pop-up that shows available keybindings as you type a prefix (e.g. <leader>),
	-- plus a searchable full list. Catppuccin already enables its which_key
	-- integration, so the popup is themed automatically.
	'folke/which-key.nvim',
	event = 'VeryLazy',
	opts = {
		preset = 'modern',
		-- Labels for the leader sub-menus. Individual mappings get their text from
		-- the `desc` set where each keymap is defined.
		spec = {
			{ '<leader>f', group = 'Find / Format' },
			{ '<leader>g', group = 'Git / Goto' },
			{ '<leader>w', group = 'Worktree / Words' },
			{ '<leader>m', group = 'Harpoon' },
			{ '<leader>o', group = 'Octo' },
			{ '<leader>d', group = 'Debug' },
			{ '<leader>s', group = 'Swap (treesitter)' },
			{ '<leader>t', group = 'Test' },
			{ '<leader>r', group = 'Rename' },
			{ '<leader>c', group = 'Code action' },
			{ '<leader>b', group = 'Buffers' },
			{ '<leader>z', group = 'Zen' },
			{ '<leader>h', group = 'Git hunk' },
		},
	},
	keys = {
		{
			'<leader>?',
			function()
				require('which-key').show { global = false }
			end,
			desc = 'Buffer-local keymaps (which-key)',
		},
	},
}
