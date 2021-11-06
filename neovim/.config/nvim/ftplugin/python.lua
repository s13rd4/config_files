local util = require('lspconfig').util

require('lspconfig').python.setup({
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
})
