require('lspconfig')['lua'].setup({
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

