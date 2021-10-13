local function on_attach()

end

local sumneko_root_path = '/home/arch/.local/share/nvim/lspinstall/lua/'
local sumneko_bin = sumneko_root_path .. '/bin/Linux/lua-language-server'

require('lspconfig').lua.setup({
	on_attach = on_attach,
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	settings = {
		runtime = {
			version = "LuaJIT",
			path = vim.split(package.path, ";")
		},
		diagnostics = { globals = {"vim"}},
		workspace = {
			library = {
				[vim.fn.expand('$VIMRUNTIME/lua')] = true,
				[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
			}
		}
	}
})

