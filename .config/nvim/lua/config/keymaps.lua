-- Set leader to SPACE
vim.g.mapleader = ' '

-- toggle on / focus on explorer (<LEADER>e)
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeFocus<cr>', { noremap = true, silent = true, desc = "open / focus explorer" })

-- open a directory (<LEADER>o)
-- TODO: need a better way to do this
vim.api.nvim_set_keymap('n', '<leader>o', ':NvimTreeToggle ', { noremap = true, silent = false, desc = "open a dir" })

-- fuzzy find (<LEADER>ff)
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<cr>', { noremap = true, silent = true, desc = "fuzzy find" })

-- format code (<LEADER>fmt)
vim.api.nvim_set_keymap('n', '<leader>fmt', ':Neoformat<cr>', { noremap = true, silent = true, desc = "format code"})

-- paste from system clipboard (p)
vim.api.nvim_set_keymap('n', 'p', '"+p', { noremap = true, silent = true, desc = "paste from system clipboard" })

-- copy to system clipboard (yy)
vim.api.nvim_set_keymap('n', 'yy', '"+yy', { noremap = true, silent = true, desc = "copy to system clipboard" })

-- search for word that cursor is on
vim.api.nvim_set_keymap('n', '<leader>fw', '<cmd>Telescope grep_string<CR>', { noremap = true, silent = true, desc = "search for word that cursor is on" })
