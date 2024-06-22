-- Source vim config
vim.cmd('source ~/.vimrc')

-- Source plugins
dofile(vim.fn.stdpath('config') .. '/plugin/init.lua')

-- Set leader to SPACE
vim.g.mapleader = ' '


-- Shortcuts
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
