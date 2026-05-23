-- nvim-treesitter `main` branch (requires Neovim 0.12+).
-- Unlike the old `master` branch there is no ensure_installed/auto_install/
-- highlight/indent config: parsers are installed via :install() and highlight
-- + indent are wired up per buffer through a FileType autocmd.
local ensure_installed = {
	'bash',
	'c',
	'css',
	'gdscript',
	'gdshader',
	'go',
	'gomod',
	'gosum',
	'gowork',
	'html',
	'javascript',
	'json',
	'lua',
	'luadoc',
	'markdown',
	'markdown_inline',
	'python',
	'query',
	'tsx',
	'typescript',
	'vim',
	'vimdoc',
	'yaml',
}

return {
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		lazy = false, -- main branch does not support lazy-loading
		build = ':TSUpdate',
		config = function()
			local ts = require 'nvim-treesitter'

			-- Install (async) any parsers we don't yet have.
			ts.install(ensure_installed)

			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('treesitter.start', { clear = true }),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
					if not lang then
						return
					end
					-- Only start when a parser is actually available; install
					-- missing ones on demand so they're ready next time.
					if not vim.treesitter.language.add(lang) then
						ts.install(lang)
						return
					end
					if pcall(vim.treesitter.start, ev.buf, lang) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		branch = 'main',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		event = 'VeryLazy',
		config = function()
			require('nvim-treesitter-textobjects').setup {
				select = { lookahead = true },
				move = { set_jumps = true },
			}

			local select = require 'nvim-treesitter-textobjects.select'
			local move = require 'nvim-treesitter-textobjects.move'
			local swap = require 'nvim-treesitter-textobjects.swap'

			-- Select (operator-pending + visual): function / class / parameter
			for _, mode in ipairs { 'x', 'o' } do
				vim.keymap.set(mode, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, { desc = 'a function' })
				vim.keymap.set(mode, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, { desc = 'inner function' })
				vim.keymap.set(mode, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, { desc = 'a class' })
				vim.keymap.set(mode, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, { desc = 'inner class' })
				vim.keymap.set(mode, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end, { desc = 'a parameter' })
				vim.keymap.set(mode, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end, { desc = 'inner parameter' })
			end

			-- Movement (']c'/'[c' are left for gitsigns hunks)
			vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next function start' })
			vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Prev function start' })
			vim.keymap.set({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end, { desc = 'Next class start' })
			vim.keymap.set({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Prev class start' })

			-- Swap parameters
			vim.keymap.set('n', '<leader>sa', function() swap.swap_next '@parameter.inner' end, { desc = 'Swap parameter with next' })
			vim.keymap.set('n', '<leader>sA', function() swap.swap_previous '@parameter.inner' end, { desc = 'Swap parameter with previous' })
		end,
	},
}
