-- Shared Python interpreter resolver for the monorepo.
--
-- Every Python tool (pyright, mypy via none-ls, neotest, dap-python) must use
-- the SAME per-package interpreter so the right virtualenv follows the active
-- file across the monorepo. That logic lives here, once.
--
-- The interpreter is taken from the nearest `.vscode/settings.json` (the
-- monorepo already defines one per package), falling back to a local venv and
-- finally the system python. Resolution never throws: packages without a
-- `.vscode` dir (or non-python buffers) just get a sensible fallback so the
-- consumers don't error on every action.
--
-- This file lives at `lua/python_env.lua` (not under `lua/plugins/`), so lazy
-- never treats it as a plugin spec; require it as `require('python_env')`.

local M = {}

-- Cache keyed by the absolute path of a settings.json, holding the parsed table
-- plus the resolved interpreter / extra paths and the mtime we parsed it at.
local settings_cache = {}
-- Per-buffer memo of the resolved settings.json path (perf only; correctness is
-- guaranteed by the mtime check below).
local buf_settings_path = {}

local uv = vim.uv or vim.loop

local function fs_mtime(path)
	local st = uv.fs_stat(path)
	return st and st.mtime and (st.mtime.sec or st.mtime) or nil
end

-- Find the nearest `.vscode/settings.json` by searching upward from the given
-- buffer's directory (NOT cwd -- buffers in a monorepo span many packages).
function M.find_vscode_settings(bufnr)
	bufnr = bufnr or 0
	if buf_settings_path[bufnr] ~= nil then
		-- false is cached as "searched, found nothing"
		return buf_settings_path[bufnr] or nil
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	local start = name ~= '' and vim.fs.dirname(name) or uv.cwd()
	local found = vim.fs.find({ '.vscode/settings.json' }, { upward = true, path = start })[1]

	buf_settings_path[bufnr] = found or false
	return found
end

-- Strip JSONC (line/block comments + trailing commas) and decode. Prefer
-- neoconf's bundled decoder so we parse `.vscode/settings.json` exactly the way
-- neoconf feeds it to pyright; fall back to vim.json after a best-effort strip.
local function decode_jsonc(str)
	local ok, jsonc = pcall(require, 'neoconf.json.jsonc')
	if ok and jsonc and jsonc.decode then
		local decoded_ok, result = pcall(jsonc.decode, str)
		if decoded_ok then
			return result
		end
	end

	-- Fallback: strip comments/trailing commas while respecting string literals,
	-- then decode with the builtin parser.
	local out, i, n = {}, 1, #str
	local in_string, escaped = false, false
	while i <= n do
		local c = str:sub(i, i)
		if in_string then
			out[#out + 1] = c
			if escaped then
				escaped = false
			elseif c == '\\' then
				escaped = true
			elseif c == '"' then
				in_string = false
			end
			i = i + 1
		elseif c == '"' then
			in_string = true
			out[#out + 1] = c
			i = i + 1
		elseif c == '/' and str:sub(i + 1, i + 1) == '/' then
			while i <= n and str:sub(i, i) ~= '\n' do
				i = i + 1
			end
		elseif c == '/' and str:sub(i + 1, i + 1) == '*' then
			i = i + 2
			while i <= n and not (str:sub(i, i) == '*' and str:sub(i + 1, i + 1) == '/') do
				i = i + 1
			end
			i = i + 2
		else
			out[#out + 1] = c
			i = i + 1
		end
	end
	-- remove trailing commas: `,` followed by optional ws then } or ]
	local stripped = table.concat(out):gsub(',%s*([}%]])', '%1')
	local ok2, result = pcall(vim.json.decode, stripped)
	if ok2 then
		return result
	end
	return nil
end

-- Read + parse the nearest settings.json for a buffer (cached on mtime).
function M.read_vscode_settings(bufnr)
	local path = M.find_vscode_settings(bufnr)
	if not path then
		return nil
	end

	local mtime = fs_mtime(path)
	local cached = settings_cache[path]
	if cached and cached.mtime == mtime then
		return cached.parsed
	end

	local lines = vim.fn.readfile(path)
	if not lines or #lines == 0 then
		settings_cache[path] = { mtime = mtime, parsed = nil }
		return nil
	end

	local parsed = decode_jsonc(table.concat(lines, '\n'))
	if parsed == nil then
		vim.notify('python_env: failed to parse ' .. path, vim.log.levels.WARN)
	end
	settings_cache[path] = { mtime = mtime, parsed = parsed, root = vim.fs.dirname(vim.fs.dirname(path)) }
	return parsed
end

-- Package root for a buffer = the directory that contains the `.vscode` dir.
function M.package_root(bufnr)
	local path = M.find_vscode_settings(bufnr)
	if not path then
		return nil
	end
	-- path = <root>/.vscode/settings.json -> dirname twice
	return vim.fs.dirname(vim.fs.dirname(path))
end

-- Expand VSCode-style variables and normalize a path string against a root.
local function expand_path(value, root)
	if type(value) ~= 'string' or value == '' then
		return nil
	end
	value = value:gsub('%${workspaceFolder}', root or '')
	value = value:gsub('%${env:([%w_]+)}', function(name)
		return vim.env[name] or ''
	end)
	value = vim.fn.expand(value)
	if not value:match('^/') and root then
		value = root .. '/' .. value
	end
	return vim.fs.normalize(value)
end

local function exists(path)
	return path ~= nil and uv.fs_stat(path) ~= nil
end

-- Resolve the absolute python executable for a buffer.
-- Priority: defaultInterpreterPath -> pythonPath -> local .venv/venv ->
-- $VIRTUAL_ENV -> system python3. Each candidate is validated before use.
function M.interpreter(bufnr)
	local root = M.package_root(bufnr)
	local settings = M.read_vscode_settings(bufnr)

	if settings then
		local candidates = {
			settings['python.defaultInterpreterPath'],
			settings['python.pythonPath'],
		}
		-- settings may also be nested (`python = { ... }`) depending on the file
		if type(settings.python) == 'table' then
			candidates[#candidates + 1] = settings.python.defaultInterpreterPath
			candidates[#candidates + 1] = settings.python.pythonPath
		end
		for _, c in ipairs(candidates) do
			local p = expand_path(c, root)
			if exists(p) then
				return p
			end
		end
	end

	if root then
		for _, rel in ipairs({ '.venv/bin/python', 'venv/bin/python' }) do
			local p = vim.fs.normalize(root .. '/' .. rel)
			if exists(p) then
				return p
			end
		end
	end

	if vim.env.VIRTUAL_ENV then
		local p = vim.fs.normalize(vim.env.VIRTUAL_ENV .. '/bin/python')
		if exists(p) then
			return p
		end
	end

	local sys = vim.fn.exepath('python3')
	if sys ~= '' then
		return sys
	end
	return nil
end

-- Directory holding the resolved interpreter (for PATH/`prefer_local` lookups).
function M.venv_bin(bufnr)
	local interp = M.interpreter(bufnr)
	return interp and vim.fs.dirname(interp) or nil
end

-- `python.analysis.extraPaths`, resolved to absolute paths. Useful for pyright
-- and for seeding PYTHONPATH for pytest/mypy/debugpy (which ignore pyright's
-- extraPaths).
function M.extra_paths(bufnr)
	local settings = M.read_vscode_settings(bufnr)
	local root = M.package_root(bufnr)
	local raw = settings and (settings['python.analysis.extraPaths']
		or (type(settings.python) == 'table' and type(settings.python.analysis) == 'table' and settings.python.analysis.extraPaths))
	local out = {}
	if type(raw) == 'table' then
		for _, p in ipairs(raw) do
			local abs = expand_path(p, root)
			if abs then
				out[#out + 1] = abs
			end
		end
	end
	return out
end

function M.clear_cache()
	settings_cache = {}
	buf_settings_path = {}
end

-- Invalidate the per-buffer memo when a buffer's name changes, and drop the
-- whole cache when any `.vscode/settings.json` is written.
local group = vim.api.nvim_create_augroup('PythonEnvCache', { clear = true })
vim.api.nvim_create_autocmd({ 'BufFilePost', 'BufDelete' }, {
	group = group,
	callback = function(ev)
		buf_settings_path[ev.buf] = nil
	end,
})
vim.api.nvim_create_autocmd({ 'BufWritePost', 'FileChangedShellPost' }, {
	group = group,
	pattern = { '*/.vscode/settings.json' },
	callback = function()
		M.clear_cache()
	end,
})

return M
