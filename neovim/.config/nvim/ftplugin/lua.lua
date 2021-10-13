local function on_attach()

end

local sumneko_root_path = '/home/arch/.local/share/nvim/lspinstall/lua/sumneko-lua'
local sumneko_bin = sumneko_root_path .. 'extension/server/bin/Linux/lua-language-server'

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require('lspconfig').sumneko_lua.setup({
	cmd = { sumneko_bin , "-E", sumneko_root_path .. "/main.lua"},
	on_attach = on_attach,
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

