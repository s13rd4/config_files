local map = vim.api.nvim_set_keymap

local defaults = { noremap = true, silent = true }

map('i','jk','<ESC>',defaults)

map('n','<C-W>h', '<CMD>lua require("tmux").move_left()<CR>' ,defaults)
map('n','<C-W>j', '<CMD>lua require("tmux").move_down()<CR>' ,defaults)
map('n','<C-W>k', '<CMD>lua require("tmux").move_up()<CR>' ,defaults)
map('n','<C-W>l', '<CMD>lua require("tmux").move_right()<CR>' ,defaults)
