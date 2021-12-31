local o = vim.o
local wo = vim.wo
local bo = vim.bo
local cmd = vim.cmd
local fn = vim.fm
local g = vim.g
local opt = vim.opt

opt.textwidth = 80
opt.clipboard = "unnamedplus"
opt.number = true
opt.cmdheight = 2
opt.completeopt = { "menuone", "noselect" }
opt.hlsearch = true
opt.pumheight = 10
opt.showmode = false
opt.showtabline = 2
opt.relativenumber = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.inccommand = "split"
opt.diffopt = {'internal','filler','vertical'}
opt.showmatch = true
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.writebackup = false
opt.updatetime = 300
opt.cursorline = true
opt.signcolumn = 'yes'
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.syntax = 'enable'

opt.splitright = true
opt.splitbelow = true

o.termguicolors = true

cmd("filetype plugin on")

g.mapleader = " "
g.maplocalleader = " "
g.material_style = 'deep ocean'
cmd[[colorscheme material]]
