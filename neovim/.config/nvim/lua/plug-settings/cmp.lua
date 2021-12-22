local cmp_status_ok, cmp = pcall(require,'cmp')
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip =  pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
	local col = vim.fn.col "." - 1
	return col == 0 or vim.fn.getline("."):sub(col,col):match "%s"
end

cmp.setup({
  completion = {
	autocomplete = false,
  },
  snippet = {
    expand = function(args)
	  luasnip.lsp_expand(args.body)
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
    { name = 'luasnip' },
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
