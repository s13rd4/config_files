local map = vim.keymap.set

local function opts(desc)
	return { noremap = true, silent = true, desc = desc }
end

map('n', '<leader>gf', '<CMD>diffget //2<CR>', opts 'Diffget //2 (target)')
map('n', '<leader>gj', '<CMD>diffget //3<CR>', opts 'Diffget //3 (merge)')
map('n', '<leader>gs', '<CMD>G<CR>', opts 'Git status (fugitive)')
map('n', '<leader>gb', '<CMD>Git branch<CR>', opts 'Git branch')
map('n', '<leader>gp', '<CMD>Git push<CR>', opts 'Git push')

-- Git worktree, driven by the git-worktree.nvim Lua API + vim.ui.select/input
-- (backed by snacks). Replaces the old telescope extension, which was never
-- loaded and therefore errored.
map('n', '<leader>ws', function()
	local worktree = require('git-worktree')
	local lines = vim.fn.systemlist('git worktree list')
	if vim.v.shell_error ~= 0 or #lines == 0 then
		vim.notify('No git worktrees found', vim.log.levels.WARN)
		return
	end
	vim.ui.select(lines, { prompt = 'Switch worktree' }, function(choice)
		if not choice then
			return
		end
		-- each line looks like: "/path/to/worktree  <sha> [branch]"
		local path = choice:match('^(%S+)')
		if path then
			worktree.switch_worktree(path)
		end
	end)
end, opts 'Switch git worktree')

map('n', '<leader>wa', function()
	local worktree = require('git-worktree')
	vim.ui.input({ prompt = 'New worktree path: ' }, function(path)
		if not path or path == '' then
			return
		end
		vim.ui.input({ prompt = 'Branch (blank = same as path): ', default = path }, function(branch)
			worktree.create_worktree(path, branch ~= '' and branch or path, 'origin')
		end)
	end)
end, opts 'Add git worktree')
