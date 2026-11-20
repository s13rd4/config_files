-- mono: white on black, with colour only for comments and strings.
-- Switch with :ThemeToggle / <leader>T (see lua/theme.lua).

vim.cmd 'highlight clear'
vim.o.background = 'dark'
vim.g.colors_name = 'mono'

local c = {
	bg = '#000000',
	fg = '#ffffff',
	comment = '#7f8c98',
	string = '#a8d08d',
	dim = '#5c5c5c', -- line numbers, borders, non-text
	subtle = '#161616', -- cursorline, colorcolumn, floats
	select = '#333333',
	red = '#ff6b6b',
	yellow = '#e5c07b',
	blue = '#7aa2f7',
	green = '#a8d08d',
}

local function hi(group, spec)
	vim.api.nvim_set_hl(0, group, spec)
end

local plain = { fg = c.fg }

-- Editor UI
hi('Normal', { fg = c.fg, bg = c.bg })
hi('NormalNC', { fg = c.fg, bg = c.bg })
hi('NormalFloat', { fg = c.fg, bg = c.bg })
hi('FloatBorder', { fg = c.dim, bg = c.bg })
hi('FloatTitle', { fg = c.fg, bg = c.bg, bold = true })
hi('ColorColumn', { bg = c.subtle })
hi('CursorLine', { bg = c.subtle })
hi('CursorColumn', { bg = c.subtle })
hi('CursorLineNr', { fg = c.fg, bold = true })
hi('LineNr', { fg = c.dim })
hi('SignColumn', { bg = c.bg })
hi('FoldColumn', { fg = c.dim, bg = c.bg })
hi('Folded', { fg = c.comment, bg = c.subtle })
hi('WinSeparator', { fg = c.dim })
hi('EndOfBuffer', { fg = c.bg })
hi('NonText', { fg = c.dim })
hi('Whitespace', { fg = c.select })
hi('SpecialKey', { fg = c.dim })
hi('Conceal', { fg = c.dim })
hi('Visual', { bg = c.select })
hi('Search', { fg = c.bg, bg = c.yellow })
hi('CurSearch', { fg = c.bg, bg = c.fg })
hi('IncSearch', { fg = c.bg, bg = c.fg })
hi('Substitute', { fg = c.bg, bg = c.yellow })
hi('MatchParen', { bold = true, underline = true })
hi('Pmenu', { fg = c.fg, bg = c.subtle })
hi('PmenuSel', { fg = c.bg, bg = c.fg })
hi('PmenuSbar', { bg = c.subtle })
hi('PmenuThumb', { bg = c.dim })
hi('StatusLine', { fg = c.fg, bg = c.subtle })
hi('StatusLineNC', { fg = c.dim, bg = c.subtle })
hi('TabLine', { fg = c.dim, bg = c.subtle })
hi('TabLineFill', { bg = c.bg })
hi('TabLineSel', { fg = c.fg, bg = c.bg, bold = true })
hi('WinBar', { fg = c.fg, bg = c.bg, bold = true })
hi('WinBarNC', { fg = c.dim, bg = c.bg })
hi('Directory', plain)
hi('Title', { fg = c.fg, bold = true })
hi('Question', plain)
hi('MoreMsg', plain)
hi('ModeMsg', { fg = c.fg, bold = true })
hi('ErrorMsg', { fg = c.red })
hi('WarningMsg', { fg = c.yellow })
hi('QuickFixLine', { bg = c.select })
hi('SpellBad', { undercurl = true, sp = c.red })
hi('SpellCap', { undercurl = true, sp = c.yellow })
hi('SpellRare', { undercurl = true, sp = c.blue })
hi('SpellLocal', { undercurl = true, sp = c.blue })

-- Syntax: everything is plain white except comments and strings.
hi('Comment', { fg = c.comment, italic = true })
hi('String', { fg = c.string })
hi('Character', { fg = c.string })
for _, group in ipairs {
	'Constant',
	'Number',
	'Boolean',
	'Float',
	'Identifier',
	'Function',
	'Statement',
	'Operator',
	'PreProc',
	'Type',
	'Special',
	'Delimiter',
	'Tag',
	'Debug',
	-- These treesitter groups carry their own colour in Neovim's defaults
	-- instead of linking to a syntax group, so flatten them explicitly.
	'@variable',
	'@markup',
} do
	hi(group, plain)
end
hi('Underlined', { fg = c.fg, underline = true })
hi('Todo', { fg = c.fg, bold = true })
hi('Error', { fg = c.red })
hi('Added', { fg = c.green })
hi('Changed', { fg = c.yellow })
hi('Removed', { fg = c.red })

-- Docstrings and string escapes follow the two highlighted classes.
hi('@string.documentation', { link = 'Comment' })
hi('@string.escape', { fg = c.string, bold = true })
hi('@string.special', { fg = c.string })
hi('@string.regexp', { fg = c.string })
hi('@markup.heading', { fg = c.fg, bold = true })
hi('@markup.strong', { bold = true })
hi('@markup.italic', { italic = true })
hi('@markup.link', { fg = c.fg, underline = true })
hi('@markup.raw', { fg = c.string })

-- Diagnostics and diffs keep a little colour: they are signals, not syntax.
hi('DiagnosticError', { fg = c.red })
hi('DiagnosticWarn', { fg = c.yellow })
hi('DiagnosticInfo', { fg = c.blue })
hi('DiagnosticHint', { fg = c.comment })
hi('DiagnosticOk', { fg = c.green })
hi('DiagnosticUnderlineError', { undercurl = true, sp = c.red })
hi('DiagnosticUnderlineWarn', { undercurl = true, sp = c.yellow })
hi('DiagnosticUnderlineInfo', { undercurl = true, sp = c.blue })
hi('DiagnosticUnderlineHint', { undercurl = true, sp = c.comment })
hi('DiagnosticUnnecessary', { fg = c.comment })
hi('DiffAdd', { bg = '#12261a' })
hi('DiffChange', { bg = '#1c1c10' })
hi('DiffDelete', { fg = c.red, bg = '#2a1215' })
hi('DiffText', { bg = '#3a3a18' })
hi('LspReferenceText', { bg = c.select })
hi('LspReferenceRead', { bg = c.select })
hi('LspReferenceWrite', { bg = c.select })
hi('LspInlayHint', { fg = c.dim, italic = true })
