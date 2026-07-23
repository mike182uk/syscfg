-- Leader key must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Respect .editorconfig files
vim.g.editorconfig = true

-- General options
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.termguicolors = true -- 24-bit colour (needed for themes)
vim.opt.clipboard = "unnamedplus" -- use the system clipboard

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false, -- load during startup
		priority = 1000, -- load before other plugins
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
})
