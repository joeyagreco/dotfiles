-- import apis
local telescope = require("telescope.builtin")
local nvim_tree = require("nvim-tree.api")

-- Set leader to SPACE
vim.g.mapleader = " "

-- toggle on / focus on explorer (<LEADER>e)
vim.keymap.set("n", "<leader>e", function()
	nvim_tree.tree.toggle({ focus = true })
end, { noremap = true, silent = true, desc = "open / focus explorer" })

-- open a directory (<LEADER>o)
-- TODO: need a better way to do this
vim.api.nvim_set_keymap("n", "<leader>o", ":NvimTreeToggle ", { noremap = true, silent = false, desc = "open a dir" })

-- format code (<LEADER>fmt)
vim.api.nvim_set_keymap("n", "<leader>fmt", ":Neoformat<cr>", { noremap = true, silent = true, desc = "format code" })

-- search for word that cursor is on (<LEADER>fw)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fw",
	"<cmd>Telescope grep_string<CR>",
	{ noremap = true, silent = true, desc = "search for word that cursor is on" }
)

-- find files (<LEADER> ff)
vim.keymap.set("n", "<leader>ff", function()
	telescope.find_files({
		follow = true, -- Follow symbolic links
	})
end, { noremap = true, silent = true, desc = "find files" })
