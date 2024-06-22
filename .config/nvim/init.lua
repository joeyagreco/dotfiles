-- load config
require('config')
require('plugin')

-- load vim config
vim.cmd('source ~/.vimrc')

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


