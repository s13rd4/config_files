local sumneko_root_path = vim.env.HOME .. '/.local/share/nvim/lspinstall/lua/sumneko-lua/extension/server'
local sumneko_bin = sumneko_root_path .. '/bin/Linux/lua-language-server'

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require('lspconfig').lua.setup({
	cmd = { sumneko_bin , "-E", sumneko_root_path .. "/main.lua"},
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path
			},
			diagnostics = {
				globals = {'vim'},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("",true)
				-- {
		--			[vim.fn.expand('$VIMRUNTIME/lua')] = true,
		--			[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
		--		},
			},
		},
	},
})
