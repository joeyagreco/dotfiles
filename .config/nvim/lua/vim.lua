local constants = require("constants")

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
