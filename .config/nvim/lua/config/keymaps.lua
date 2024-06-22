-- Set leader to SPACE
vim.g.mapleader = ' '

-- toggle on / focus on explorer (<LEADER>e)
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeFocus<cr>', { noremap = true, silent = true })

-- fuzzy find (<LEADER>ff)
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<cr>', { noremap = true, silent = true })

-- TODO: find somewhere to put helper funcs
function CloseNvimTreeIfOpen()
	local view = require'nvim-tree.view'
	if view.is_visible() then
	  view.close()
	end
  end

-- close explorer (<LEADER>x)
vim.api.nvim_set_keymap('n', '<leader>x', [[:lua CloseNvimTreeIfOpen()<CR>]], { noremap = true, silent = true })

