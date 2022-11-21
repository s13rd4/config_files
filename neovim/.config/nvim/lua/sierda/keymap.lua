local M = {}

local function bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_exetend("force",
			outer_opts,
			opts or {}
		)
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

local function buffer_bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(buf,lhs, rhs, opts)
		opts = vim.tbl_exetend("force",
			outer_opts,
			opts or {}
		)
		vim.api.nvim_buf_set_keymap(buf,op,lhs,rhs,opts)
	end
end


M.bnmap = buffer_bind("n", { noremap = false })
M.bnnoremap = buffer_bind("n")
M.bvnoremap = buffer_bind("v")
M.bxnoremap = buffer_bind("x")
M.binoremap = buffer_bind("i")
M.btnoremap = buffer_bind("t")
M.bcnoremap = buffer_bind("c")

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")
M.tnoremap = bind("t")
M.cnoremap = bind("c")

return M
