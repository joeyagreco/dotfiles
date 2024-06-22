-- Source vim config
vim.cmd('source ~/.vimrc')

-- Source plugins
dofile(vim.fn.stdpath('config') .. '/plugin/init.lua')

-- Source shortcuts
dofile(vim.fn.stdpath('config') .. '/shortcuts.lua')

-- Enable copy/paste
vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
        ['+'] = 'pbcopy',
        ['*'] = 'pbcopy',
    },
    paste = {
        ['+'] = 'pbpaste',
        ['*'] = 'pbpaste',
    },
    cache_enabled = true,
}


