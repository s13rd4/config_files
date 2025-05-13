return {
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
			local config = require 'nvim-treesitter.configs'
			config.setup {
				ensure_installed = 'all',
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				disable = function(lang, buf)
					local max_filesize = 1024 * 1024 -- 1 MB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
            return true
					end
				end,
			}
		end,
	},
	{ 'nvim-treesitter/playground' },
}
