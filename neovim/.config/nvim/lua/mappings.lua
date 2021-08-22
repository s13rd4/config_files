local map = vim.api.nvim_set_keymap

local defaults = { noremap = true, silent = true }

map('i','jk','<ESC>',defaults)
