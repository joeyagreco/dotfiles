-- source vim config
vim.cmd('source ~/.vimrc')

-- source plugins
--dofile('plugin/init.lua')

dofile(vim.fn.stdpath('config') .. '/plugin/init.lua')

-- set leader to SPACE
vim.g.mapleader = ' '

