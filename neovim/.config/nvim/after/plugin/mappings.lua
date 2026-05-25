local map = vim.keymap.set

local function defaults(desc)
	return { noremap = true, silent = true, desc = desc }
end

local function term_opts(desc)
	return { silent = true, desc = desc }
end

-- move the visual selection down/up, reselecting and reindenting after
map('v', '<A-j>', ":m '>+1<CR>gv=gv", defaults 'Move selection down')
map('v', '<A-k>', ":m '<-2<CR>gv=gv", defaults 'Move selection up')
map('v', 'K', ":m '>-2<CR>gv=gv", defaults 'Move selection up')
map('v', 'J', ":m '>+1<CR>gv=gv", defaults 'Move selection down')

map('i', 'jk', '<ESC>', defaults 'Exit insert mode')

map('n', '<C-Up>', '<CMD>resize +2<CR>', defaults 'Grow window height')
map('n', '<C-Down>', '<CMD>resize -2<CR>', defaults 'Shrink window height')
map('n', '<C-Left>', '<CMD>vertical resize +2<CR>', defaults 'Grow window width')
map('n', '<C-Right>', '<CMD>vertical resize -2<CR>', defaults 'Shrink window width')

map('t', '<C-h>', '<C-\\><C-N><C-w>h', term_opts 'Go to left window')
map('t', '<C-j>', '<C-\\><C-N><C-w>j', term_opts 'Go to lower window')
map('t', '<C-l>', '<C-\\><C-N><C-w>l', term_opts 'Go to right window')
map('t', '<C-k>', '<C-\\><C-N><C-w>k', term_opts 'Go to upper window')
