local o = vim.o
local wo = vim.wo
local bo = vim.bo
local cmd = vim.cmd
local fn = vim.fm
local g = vim.g
local opt = vim.opt


opt.textwidth = 80
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.inccommand = "split"
opt.diffopt = {'internal','filler','vertical'}
opt.showmatch = true

opt.syntax = 'enable'

opt.splitright = true
opt.splitbelow = true

cmd("filetype plugin on")

g.mapleader = " "
vim.cmd[[colorscheme material]]
