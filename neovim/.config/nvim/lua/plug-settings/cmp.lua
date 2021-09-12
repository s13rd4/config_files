local cmp = require('cmp')
cmp.setup({
  completion = {
	autocomplete = false,
  },
  snippet = {
    expand = function(args)
	  vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
	['<C-d'] = cmp.mapping.scroll_docs(-4),
	['<C-f'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ cmp.ConfirmBehavior.Replace,
	  select = true }),
	['<C-e>'] = cmp.mapping.close(),
	['<C-Space>'] = cmp.mapping.complete()
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'calc' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'treesitter' },
  }
})
