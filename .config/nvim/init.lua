-- Source vim config
vim.cmd('source ~/.vimrc')

-- Source plugins
dofile(vim.fn.stdpath('config') .. '/plugin/init.lua')

-- Set leader to SPACE
vim.g.mapleader = ' '

-- Shortcuts

-- open explorer (<LEADER>e)
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
