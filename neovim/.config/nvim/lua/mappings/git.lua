local map = vim.api.nvim_set_keymap

local defaults = { noremap = true, silent = true }

map('n','<leader>gf' ,'<CMD>diffget //2<CR>',defaults)
map('n','<leader>gj' ,'<CMD>diffget //3<CR>',defaults)
map('n','<leader>gs' ,'<CMD>:G<CR>',defaults)
map('n','<leader>gb' ,'<CMD>:Git branch<CR>',defaults)
map('n','<leader>gp' ,'<CMD>:Git push<CR>',defaults)
map('n','<leader>ws' ,'<CMD>:lua require("telescope").extensions.git_worktree.git_worktrees()<CR>',defaults)
map('n','<leader>wa' ,'<CMD>:lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>',defaults)
