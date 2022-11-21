local Remap = require("sierda.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local function config(_config)
	return vim.tbl_deep_extend("force", {
		on_attach = function()
			--local function bnnoremap(...)
				--Remap.bnnoremap(bufnr, ...)
			--end
--
			--local function binoremap(...)
				--Remap.binoremap(bufnr, ...)
			--end

			nnoremap("gD", function() vim.lsp.buf.declaration() end)
			nnoremap("gd", function() vim.lsp.buf.definition() end)
			nnoremap("gi", function() vim.lsp.buf.implementation() end)
			nnoremap("K", function() vim.lsp.buf.hover() end)
			nnoremap("<C-k>", function() vim.lsp.buf.signature_help() end)
			nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
			nnoremap("[d", function() vim.diagnostic.goto_next() end)
			nnoremap("]d", function() vim.diagnostic.goto_prev() end)
			nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end)
			nnoremap("<leader>vco", function() vim.lsp.buf.code_action({
					filter = function(code_action)
						if not code_action or not code_action.data then
							return false
						end

						local data = code_action.data.id
						return string.sub(data, #data - 1, #data) == ":0"
					end,
					apply = true })
			end)
			nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
			nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
			inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
			nnoremap("<leader>f", function() vim.lsp.buf.format() end)
		end,
	}, _config or {})
end

local sumneko_root_path = vim.env.HOME .. '/.local/share/nvim/lsp_servers/sumneko_lua/extension/server'
local sumneko_bin = sumneko_root_path .. '/bin/lua-language-server'
require("lspconfig").sumneko_lua.setup(config({
	cmd = { sumneko_bin, "-E", sumneko_root_path .. "/main.lua" },
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true)
			},
			telemetry = {
				enable = false,
			}
		},
	},
}))


local goplsbin = vim.env.HOME .. '/.local/share/nvim/lsp_servers/go/gopls'
require('lspconfig').gopls.setup(config({
	cmd = { goplsbin, 'serve' },
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
		},
	}
}))


local util = require('lspconfig').util
local pyrightbin = vim.env.HOME .. '/.local/share/nvim/lsp_servers/python/node_modules/.bin/pyright-langserver'
require('lspconfig').pyright.setup(config({
	cmd = { pyrightbin, "--stdio" },
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	root_dir = function(fname)
		local root_files = {
			'pyproject.toml',
			'setup.py',
			'setup.cfg',
			'requirements.txt',
			'Pipfile',
			'pyrighitconfig.json',
		}
		return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
	end,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			}
		}
	}
}))
