-- Shared Python interpreter / path resolver for the monorepo.
--
-- Every Python tool (pyright, mypy via none-ls, neotest, dap-python) must use
-- the SAME per-package interpreter and import paths so the right virtualenv and
-- PYTHONPATH follow the active file across the monorepo. That logic lives here.
--
-- Sources, in VSCode precedence order:
--   1. the package's `.vscode/settings.json`            (per-folder, wins)
--   2. the root multi-root `*.code-workspace` `settings` (workspace fallback)
--   3. the `python.envFile` (default `${workspaceFolder}/.env`) for PYTHONPATH
-- Then local `.venv`/`venv`, `$VIRTUAL_ENV`, and finally the system python.
--
-- Resolution never throws: packages without any of these just get a sensible
-- fallback so the consumers don't error on every action.
--
-- This file lives at `lua/python_env.lua` (not under `lua/plugins/`), so lazy
-- never treats it as a plugin spec; require it as `require('python_env')`.

local M = {}

local uv = vim.uv or vim.loop

-- Caches keyed by the absolute file path, each guarded by an mtime check so
-- edits are picked up without a restart. The per-buffer memos are perf only.
local settings_cache = {}
local workspace_cache = {}
local env_cache = {}
local buf_settings_path = {}
local buf_workspace_path = {}

local function fs_mtime(path)
	local st = uv.fs_stat(path)
	return st and st.mtime and (st.mtime.sec or st.mtime) or nil
end

local function exists(path)
	return path ~= nil and uv.fs_stat(path) ~= nil
end

-- Strip JSONC (line/block comments + trailing commas) and decode. Prefer
-- neoconf's bundled decoder so we parse `.vscode` files exactly the way neoconf
-- feeds them to pyright; fall back to vim.json after a best-effort strip.
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

local function read_json_file(path, cache, label)
	local mtime = fs_mtime(path)
	local cached = cache[path]
	if cached and cached.mtime == mtime then
		return cached.parsed
	end
	local lines = vim.fn.readfile(path)
	local parsed = (lines and #lines > 0) and decode_jsonc(table.concat(lines, '\n')) or nil
	if parsed == nil and lines and #lines > 0 then
		vim.notify('python_env: failed to parse ' .. (label or path), vim.log.levels.WARN)
	end
	cache[path] = { mtime = mtime, parsed = parsed }
	return parsed
end

local function buf_dir(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr or 0)
	return name ~= '' and vim.fs.dirname(name) or uv.cwd()
end

-- Find the nearest `.vscode/settings.json` by searching upward from the given
-- buffer's directory (NOT cwd -- buffers in a monorepo span many packages).
function M.find_vscode_settings(bufnr)
	bufnr = bufnr or 0
	if buf_settings_path[bufnr] ~= nil then
		return buf_settings_path[bufnr] or nil
	end
	local found = vim.fs.find({ '.vscode/settings.json' }, { upward = true, path = buf_dir(bufnr) })[1]
	buf_settings_path[bufnr] = found or false
	return found
end

-- Find the nearest `*.code-workspace` (usually at the monorepo root).
function M.find_workspace_file(bufnr)
	bufnr = bufnr or 0
	if buf_workspace_path[bufnr] ~= nil then
		return buf_workspace_path[bufnr] or nil
	end
	local found = vim.fs.find(function(fname)
		return fname:match('%.code%-workspace$') ~= nil
	end, { upward = true, path = buf_dir(bufnr), type = 'file' })[1]
	buf_workspace_path[bufnr] = found or false
	return found
end

-- Read + parse the nearest per-folder settings.json (cached on mtime).
function M.read_vscode_settings(bufnr)
	local path = M.find_vscode_settings(bufnr)
	return path and read_json_file(path, settings_cache, path) or nil
end

-- Read + parse the nearest `*.code-workspace` (cached on mtime).
function M.read_workspace(bufnr)
	local path = M.find_workspace_file(bufnr)
	return path and read_json_file(path, workspace_cache, path) or nil
end

-- Directory containing the `*.code-workspace` file.
function M.workspace_root(bufnr)
	local path = M.find_workspace_file(bufnr)
	return path and vim.fs.dirname(path) or nil
end

-- Absolute workspace folders from the `.code-workspace` `folders` list. Each
-- `path` is relative to the workspace-file dir.
function M.workspace_folders(bufnr)
	local ws = M.read_workspace(bufnr)
	local dir = M.workspace_root(bufnr)
	local out = {}
	if ws and type(ws.folders) == 'table' and dir then
		for _, f in ipairs(ws.folders) do
			if type(f.path) == 'string' then
				local abs = f.path:match('^/') and f.path or (dir .. '/' .. f.path)
				out[#out + 1] = { path = vim.fs.normalize(abs), name = f.name }
			end
		end
	end
	return out
end

local function folders_by_name(bufnr)
	local map = {}
	for _, f in ipairs(M.workspace_folders(bufnr)) do
		if f.name then
			map[f.name] = f.path
		end
	end
	return map
end

-- Package root for a buffer = the directory holding its `.vscode` dir, or (when
-- a folder has no `.vscode`) the deepest `.code-workspace` folder that contains
-- the buffer.
function M.package_root(bufnr)
	local path = M.find_vscode_settings(bufnr)
	if path then
		return vim.fs.dirname(vim.fs.dirname(path))
	end
	local name = vim.api.nvim_buf_get_name(bufnr or 0)
	if name ~= '' then
		local dir = vim.fs.normalize(vim.fs.dirname(name))
		local best
		for _, f in ipairs(M.workspace_folders(bufnr)) do
			if dir == f.path or dir:sub(1, #f.path + 1) == f.path .. '/' then
				if not best or #f.path > #best then
					best = f.path
				end
			end
		end
		return best
	end
	return nil
end

-- Look a (possibly dotted) VSCode key up in a settings table, supporting both
-- the flat form (`["python.defaultInterpreterPath"]`) and nested tables.
local function lookup(tbl, dotted_key)
	if type(tbl) ~= 'table' then
		return nil
	end
	if tbl[dotted_key] ~= nil then
		return tbl[dotted_key]
	end
	local cur = tbl
	for part in dotted_key:gmatch('[^.]+') do
		if type(cur) ~= 'table' then
			return nil
		end
		cur = cur[part]
		if cur == nil then
			return nil
		end
	end
	return cur
end

-- Layered setting lookup: per-folder `.vscode/settings.json` first, then the
-- `.code-workspace` `settings` block (VSCode precedence).
function M.get_setting(bufnr, key)
	local v = lookup(M.read_vscode_settings(bufnr), key)
	if v ~= nil then
		return v
	end
	local ws = M.read_workspace(bufnr)
	return ws and lookup(ws.settings, key) or nil
end

-- Expand VSCode-style variables and normalize a path against a root.
-- `${workspaceFolder}` resolves to the buffer's package folder; the named
-- `${workspaceFolder:Name}` resolves via the `.code-workspace` folder list.
local function expand_path(value, root, fbn)
	if type(value) ~= 'string' or value == '' then
		return nil
	end
	value = value:gsub('%${workspaceFolder:([%w_%-%.]+)}', function(name)
		return (fbn and fbn[name]) or root or ''
	end)
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

-- Resolve the absolute python executable for a buffer.
-- Priority: defaultInterpreterPath -> pythonPath (each: folder then workspace)
-- -> local .venv/venv -> $VIRTUAL_ENV -> system python3.
function M.interpreter(bufnr)
	local root = M.package_root(bufnr)
	local fbn = folders_by_name(bufnr)

	for _, key in ipairs({ 'python.defaultInterpreterPath', 'python.pythonPath' }) do
		local p = expand_path(M.get_setting(bufnr, key), root, fbn)
		if exists(p) then
			return p
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

-- Resolve the `python.envFile` for a buffer (default `${workspaceFolder}/.env`).
function M.env_file(bufnr)
	local root = M.package_root(bufnr)
	local raw = M.get_setting(bufnr, 'python.envFile')
	if type(raw) ~= 'string' or raw == '' then
		raw = '${workspaceFolder}/.env'
	end
	local p = expand_path(raw, root, folders_by_name(bufnr))
	return exists(p) and p or nil
end

-- Parse a dotenv file into a flat KEY=VALUE table (cached on mtime).
local function parse_env_file(path)
	local mtime = fs_mtime(path)
	local cached = env_cache[path]
	if cached and cached.mtime == mtime then
		return cached.vars
	end
	local vars = {}
	for _, line in ipairs(vim.fn.readfile(path) or {}) do
		local l = line:gsub('^%s+', '')
		if l ~= '' and l:sub(1, 1) ~= '#' then
			l = l:gsub('^export%s+', '')
			local key, val = l:match('^([%w_]+)%s*=%s*(.*)$')
			if key then
				local first = val:sub(1, 1)
				if first == '"' or first == "'" then
					val = val:gsub('^"(.*)"$', '%1'):gsub("^'(.*)'$", '%1')
				else
					val = val:gsub('%s+#.*$', '') -- best-effort inline comment strip
				end
				vars[key] = val
			end
		end
	end
	env_cache[path] = { mtime = mtime, vars = vars }
	return vars
end

-- Absolute import dirs from the env file's PYTHONPATH (entries relative to the
-- env-file dir). `${PYTHONPATH}` / `$PYTHONPATH` self-references expand to the
-- inherited value.
function M.pythonpath(bufnr)
	local file = M.env_file(bufnr)
	if not file then
		return {}
	end
	local pp = parse_env_file(file).PYTHONPATH
	if type(pp) ~= 'string' or pp == '' then
		return {}
	end
	local inherited = vim.env.PYTHONPATH or ''
	pp = pp:gsub('%${PYTHONPATH}', inherited):gsub('%$PYTHONPATH', inherited)
	local base = vim.fs.dirname(file)
	local fbn = folders_by_name(bufnr)
	local out = {}
	for entry in vim.gsplit(pp, ':', { plain = true }) do
		if entry ~= '' then
			local abs = expand_path(entry, base, fbn)
			if abs then
				out[#out + 1] = abs
			end
		end
	end
	return out
end

-- `python.analysis.extraPaths` (folder then workspace) plus the env-file
-- PYTHONPATH, resolved to absolute paths. Seeds pyright's import resolution.
function M.extra_paths(bufnr)
	local root = M.package_root(bufnr)
	local fbn = folders_by_name(bufnr)
	local out = {}
	local raw = M.get_setting(bufnr, 'python.analysis.extraPaths')
	if type(raw) == 'table' then
		for _, p in ipairs(raw) do
			local abs = expand_path(p, root, fbn)
			if abs then
				out[#out + 1] = abs
			end
		end
	end
	for _, p in ipairs(M.pythonpath(bufnr)) do
		out[#out + 1] = p
	end
	return out
end

-- Environment overrides for tools that spawn the interpreter (mypy, pytest).
-- PYTHONPATH (prepended to the inherited value) for runtime import resolution;
-- MYPYPATH because mypy searches that, not PYTHONPATH.
function M.run_env(bufnr)
	local pp = M.pythonpath(bufnr)
	if #pp == 0 then
		return {}
	end
	local joined = table.concat(pp, ':')
	local inherited = vim.env.PYTHONPATH
	return {
		PYTHONPATH = (inherited and inherited ~= '') and (joined .. ':' .. inherited) or joined,
		MYPYPATH = joined,
	}
end

function M.clear_cache()
	settings_cache = {}
	workspace_cache = {}
	env_cache = {}
	buf_settings_path = {}
	buf_workspace_path = {}
end

-- Invalidate per-buffer memos when a buffer's name changes, and drop the whole
-- cache when any VSCode config or env file is written. Arbitrary `envFile`
-- names are still picked up via the per-file mtime checks above.
local group = vim.api.nvim_create_augroup('PythonEnvCache', { clear = true })
vim.api.nvim_create_autocmd({ 'BufFilePost', 'BufDelete' }, {
	group = group,
	callback = function(ev)
		buf_settings_path[ev.buf] = nil
		buf_workspace_path[ev.buf] = nil
	end,
})
vim.api.nvim_create_autocmd({ 'BufWritePost', 'FileChangedShellPost' }, {
	group = group,
	pattern = { '*/.vscode/settings.json', '*.code-workspace', '*.env', '.env' },
	callback = function()
		M.clear_cache()
	end,
})

return M
