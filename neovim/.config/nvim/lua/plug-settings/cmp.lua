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

local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
  snippet = {
    expand = function(args)
	  luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
	['<C-d'] = cmp.mapping(cmp.mapping.scroll_docs(-4),{ 'i','c' }),
	['<C-f'] = cmp.mapping(cmp.mapping.scroll_docs(4),{ 'i','c' }),
	['<C-Space'] = cmp.mapping(cmp.mapping.complete(),{ 'i','c' }),
    ['<CR>'] = cmp.mapping.confirm({ cmp.ConfirmBehavior.Replace, select = true }),
	['<C-e>'] = cmp.mapping {
		i = cmp.mapping.abort(),
		c = cmp.mapping.close()
	},
	["<C-n>"] = cmp.mapping(function (fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expandable() then
			luasnip.expand()
		elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		elseif check_backspace() then
			fallback()
		else
			fallback()
		end	
	end,{"i","s"}),
	["<C-p>"] = cmp.mapping(function (fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, {"i","s"})
  },

  formatting = {
	fieds = {"kind","abbr","menu"},
	format = function (entry,vim_item)
		vim_item.kind = string.format("%s %s",kind_icons[vim_item.kind], vim_item.kind)
		vim_item.menu = ({
			nvim_lsp = "[LSP]",
			nvim_lua = "[NVIM_LUA]",
			luasnip = "[Snippet]",
			buffer = "[Buffer]",
			path = "[Path]",
		})[entry.source.name]
		return vim_item
	end,
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'calc' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'treesitter' },
  },
  window = {
	  documentation = {
		border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"},
	  }
  },
  confirm_opts = { behavior = cmp.ConfirmBehavior.Replace, select = false},
  experimental = {
	ghost_text = false,
	native_menu =  false,
  }
})

cmp.setup.cmdline('/',{
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':',{
  sources = cmp.config.sources({
    { name = 'path' } ,
	{ name = 'cmdline' }
  })
})
