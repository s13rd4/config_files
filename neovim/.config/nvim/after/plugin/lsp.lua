local Remap = require("sierda.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local sumneko_root_path = vim.env.HOME .. '/.local/share/nvim/lsp_servers/sumneko_lua/extension/server'
local sumneko_bin = sumneko_root_path .. '/bin/lua-language-server'

local function config(_config)
	return vim.tbl_deep_extend("force", {
		on_attach = function(client)
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
                apply = true
            })
			end)
			nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
			nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
			inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
			if client.server_capabilities.document_formatting then
				nnoremap("ff",function() vim.lsp.buf.formatting() end)
			elseif client.server_capabilities.document_range_formatting then
				nnoremap("ff",function() vim.lsp.buf.range_formatting() end)
			end
		end,
	},_config or {})
end

require("lspconfig").sumneko_lua.setup(config({
	cmd = { sumneko_bin, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	},
}))


