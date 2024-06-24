-- import apis
local telescope = require("telescope.builtin")
local nvim_tree = require("nvim-tree.api")

-- Set leader to SPACE
vim.g.mapleader = " "

-- toggle on / focus on explorer (<LEADER>e)
vim.keymap.set("n", "<leader>e", function()
	nvim_tree.tree.open({ focus = true })
end, { noremap = true, silent = true, desc = "open / focus explorer" })

-- format code (<LEADER>fmt)
vim.api.nvim_set_keymap("n", "<leader>fmt", ":Neoformat<cr>", { noremap = true, silent = true, desc = "format code" })

-- search for word that cursor is on (<LEADER>fw)
vim.keymap.set("n", "<leader>fw", function()
	telescope.grep_string({
		word_match = "-w",
		search = vim.fn.expand("<cword>"),
	})
end, { noremap = true, silent = true, desc = "search for word under cursor" })

-- Find files (<LEADER> ff)
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files({
		hidden = true,
		file_ignore_patterns = { "node_modules", "build", "dist", "yarn.lock", ".git" },
	})
end, { noremap = true, silent = true, desc = "find files" })
