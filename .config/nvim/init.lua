-- load vim config
vim.cmd('source ~/.vimrc')

-- load config
require('keymaps')
require('theme')


-- TODO: i dont think this is needed
-- -- Enable copy/paste
-- vim.g.clipboard = {
--     name = 'pbcopy',
--     copy = {
--         ['+'] = 'pbcopy',
--         ['*'] = 'pbcopy',
--     },
--     paste = {
--         ['+'] = 'pbpaste',
--         ['*'] = 'pbpaste',
--     },
--     cache_enabled = true,
-- }


