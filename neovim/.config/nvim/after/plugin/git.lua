local map = vim.api.nvim_set_keymap

local function opts(desc)
	return { noremap = true, silent = true, desc = desc }
end

map('n', '<leader>gf', '<CMD>diffget //2<CR>', opts 'Diffget //2 (target)')
map('n', '<leader>gj', '<CMD>diffget //3<CR>', opts 'Diffget //3 (merge)')
map('n', '<leader>gs', '<CMD>:G<CR>', opts 'Git status (fugitive)')
map('n', '<leader>gb', '<CMD>:Git branch<CR>', opts 'Git branch')
map('n', '<leader>gp', '<CMD>:Git push<CR>', opts 'Git push')
map('n', '<leader>ws', '<CMD>:lua require("telescope").extensions.git_worktree.git_worktrees()<CR>', opts 'Switch git worktree')
map('n', '<leader>wa', '<CMD>:lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>', opts 'Add git worktree')
