local map = vim.keymap.set

local defaults = { noremap = true, silent = true }

local term_opts = { silent = true }

map("x", "<A-j>", ":move '>+1<CR>gv-gv")
map("x", "<A-k>", ":move '<-2<CR>gv-gv")
map('v', '<A-j>', '<CMD>m .+1<CR>==', defaults)
map('v', '<A-k>', '<CMD>m .-2<CR>==', defaults)
map('v', 'K', ":m '>-2<CR>gv=gv")
map('v', 'J', ":m '>+1<CR>gv=gv")


map('i', 'jk', '<ESC>', defaults)

map('n', '<C-Up>', "<CMD>resize +2<CR>", defaults)
map('n', '<C-Down>', "<CMD>resize -2<CR>", defaults)
map('n', '<C-Left>', "<CMD>vertical resize +2<CR>", defaults)
map('n', '<C-Right>', "<CMD>vertical resize -2<CR>", defaults)


map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
