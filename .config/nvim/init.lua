-- load vim config
vim.cmd('source ~/.vimrc')

-- load config
require('plugin')
require('config')



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


