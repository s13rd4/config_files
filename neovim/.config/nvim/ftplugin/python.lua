local function on_attach()

end

require('lspconfig').python.setup({
	on_attach = on_attach,
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})
