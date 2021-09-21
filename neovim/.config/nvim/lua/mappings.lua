local map = vim.api.nvim_set_keymap

local defaults = { noremap = true, silent = true }

map('i','jk','<ESC>',defaults)
map('n','<leader>ff' ,'<CMD>lua require("telescope.builtin").find_files()<CR>',defaults)
map('n','<leader>fg' ,'<CMD>lua require("telescope.builtin").live_grep()<CR>',defaults)
map('n','<leader>fb' ,'<CMD>lua require("telescope.builtin").buffers()<CR>',defaults)
map('n','<leader>fh' ,'<CMD>lua require("telescope.builtin").git_files()<CR>',defaults)
