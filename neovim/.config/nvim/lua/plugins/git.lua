return {
	{ 'tpope/vim-fugitive' },
	{ 'tpope/vim-rhubarb' },
	{ 'ThePrimeagen/git-worktree.nvim' },
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				local gs = require 'gitsigns'
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map('n', '<leader>hp', gs.preview_hunk, 'Preview git hunk')
				map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk (toggle)')
				map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
				map('v', '<leader>hs', function()
					gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
				end, 'Stage selected hunk')
				map('v', '<leader>hr', function()
					gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
				end, 'Reset selected hunk')
				map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
				map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
				map('n', '<leader>hb', function()
					gs.blame_line { full = true }
				end, 'Blame line')
				map('n', '<leader>hd', gs.diffthis, 'Diff against index')

				-- ]c / [c navigate hunks (kept separate so they fall back to the
				-- built-in/fugitive diff-mode behaviour when in a diff).
				vim.keymap.set({ 'n', 'v' }, ']c', function()
					if vim.wo.diff then
						return ']c'
					end
					vim.schedule(function()
						gs.nav_hunk 'next'
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
				vim.keymap.set({ 'n', 'v' }, '[c', function()
					if vim.wo.diff then
						return '[c'
					end
					vim.schedule(function()
						gs.nav_hunk 'prev'
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
			end,
		},
	},
}
