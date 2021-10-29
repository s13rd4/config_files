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
	['<C-d'] = cmp.mapping(cmp.mapping.scroll_docs(-4),{ 'i','c' }),
	['<C-f'] = cmp.mapping(cmp.mapping.scroll_docs(4),{ 'i','c' }),
    ['<CR>'] = cmp.mapping.confirm({ cmp.ConfirmBehavior.Replace, select = true }),
	['<C-e>'] = cmp.mapping.close(),
	['<C-Space>'] = cmp.mapping(cmp.mapping.complete(),{ 'i','c' }),
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

cmp.setup.cmdline('/',{
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':',{
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
	{ name = 'cmdline' }
  })
})
