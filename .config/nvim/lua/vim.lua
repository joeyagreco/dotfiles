local constants = require("constants")

-- set leader to SPACE
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- enable the live preview of substitution commands in a split window
vim.opt.inccommand = "split"

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

-- fold config
-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- disable netrw for nvim-tree
-- :help nvim-tree-netrw
-- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#install
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set python to use
vim.g.python3_host_prog = constants.PYTHON_PATH

-- no splash screen on startup
-- vim.opt.shortmess:append("I")

-- enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent = true

-- decrease updatetime to 250ms
vim.opt.updatetime = 250

-- set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- enable persistent undo history
vim.opt.undofile = true

-- enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"
