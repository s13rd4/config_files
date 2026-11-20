-- Theme switching between catppuccin (default) and mono (colors/mono.lua).
-- The choice is remembered across sessions in stdpath('state').

local M = {}

local default = 'catppuccin'
local themes = { 'catppuccin', 'mono' }
local state_file = vim.fn.stdpath 'state' .. '/theme'

-- Themes that show a guide at this column.
local colorcolumn = { mono = '80' }

local function saved()
	local f = io.open(state_file, 'r')
	if not f then
		return default
	end
	local name = vim.trim(f:read '*a' or '')
	f:close()
	return vim.tbl_contains(themes, name) and name or default
end

local function save(name)
	local f = io.open(state_file, 'w')
	if f then
		f:write(name)
		f:close()
	end
end

local function sync_colorcolumn()
	local value = colorcolumn[vim.g.colors_name] or ''
	vim.go.colorcolumn = value
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		vim.wo[win].colorcolumn = value
	end
end

function M.set(name)
	if not pcall(vim.cmd.colorscheme, name) then
		vim.notify('theme: cannot load ' .. name, vim.log.levels.ERROR)
		return
	end
	save(name)
end

function M.toggle()
	M.set(vim.g.colors_name == 'mono' and 'catppuccin' or 'mono')
end

-- Apply the remembered theme; called once the colorscheme plugin is loaded.
function M.setup()
	vim.api.nvim_create_autocmd('ColorScheme', {
		group = vim.api.nvim_create_augroup('theme_colorcolumn', { clear = true }),
		callback = sync_colorcolumn,
	})
	vim.api.nvim_create_user_command('ThemeToggle', M.toggle, { desc = 'Toggle catppuccin / mono theme' })
	vim.keymap.set('n', '<leader>T', M.toggle, { desc = 'Toggle theme (catppuccin / mono)' })

	if not pcall(vim.cmd.colorscheme, saved()) then
		vim.cmd.colorscheme(default)
	end
end

return M
