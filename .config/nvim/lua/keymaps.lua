-- import apis
local telescope = require("telescope.builtin")
local nvim_tree = require("nvim-tree.api")
local harpoon = require("harpoon")

-- keep track of custom keymaps by letter to prevent collision delay
-- a
-- c
-- e
-- ff
-- fh
-- fm
-- fs
-- fw
-- gd
-- ho
-- K
-- m
-- tc

-- Set leader to SPACE
vim.g.mapleader = " "

-- toggle on / focus on explorer (<LEADER>e)
vim.keymap.set("n", "<leader>e", function()
	nvim_tree.tree.open({ focus = true })
end, { noremap = true, silent = true, desc = "open / focus explorer" })

-- format code (<LEADER>fm)
vim.api.nvim_set_keymap("n", "<leader>fm", ":Neoformat<cr>", { noremap = true, silent = true, desc = "format code" })

-- search for word that cursor is on (<LEADER>fw)
vim.keymap.set("n", "<leader>fw", function()
	telescope.grep_string({
		word_match = "-w",
		search = vim.fn.expand("<cword>"),
	})
end, { noremap = true, silent = true, desc = "search for word under cursor" })

-- serach for a word (<LEADER>fs)
vim.keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "open popup to search for words" })

-- find files (<LEADER>ff)
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files({})
end, { noremap = true, silent = true, desc = "find files" })

-- find files including hidden (<LEADER>fh)
vim.keymap.set("n", "<leader>fh", function()
	require("telescope.builtin").find_files({
		hidden = true,
		file_ignore_patterns = { "node_modules", "build", "dist", "yarn.lock", ".git" },
	})
end, { noremap = true, silent = true, desc = "find files including hidden" })

-- open up tree to the current file (<LEADER>tc)
vim.keymap.set(
	"n",
	"<leader>tc",
	":NvimTreeFindFile<CR>",
	{ noremap = true, silent = true, desc = "Ooen nvim tree to current file" }
)

-- go to definition for whatever the cursor is on (<LEADER>gd)
vim.keymap.set(
	"n",
	"<leader>gd",
	vim.lsp.buf.definition,
	{ noremap = true, silent = true, desc = "go to definition for whatever the cursor is on" }
)

-- add to harpoon menu (<LEADER>a)
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { noremap = true, silent = true, desc = "add current file to harpoon menu" })

-- open harpoon menu (<LEADER>m)
vim.keymap.set("n", "<leader>m", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { noremap = true, silent = true, desc = "open harpoon menu" })

-- clear harpoon menu (<LEADER>c)
vim.keymap.set("n", "<leader>c", function()
	harpoon:list():clear()
end, { noremap = true, silent = true, desc = "clear harpoon menu" })

-- Toggle previous & next buffers stored within Harpoon list
-- (<CTRL>p) (<CTRL>n)
vim.keymap.set("n", "<C-P>", function()
	harpoon:list():prev()
end, { noremap = true, silent = true, desc = "prev harpoon buffer" })

vim.keymap.set("n", "<C-N>", function()
	harpoon:list():next()
end, { noremap = true, silent = true, desc = "next harpoon buffer" })

-- 'if __name__ == "__main__"' (<LEADER>inm)
vim.keymap.set(
	"n",
	"<leader>inm",
	'iif __name__ == "__main__":<Esc>o',
	{ noremap = true, silent = true, desc = "if name == main " }
)

-- get lsp info for whatever the cursor is on (K)
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Show info popup over function" })

-- turn search highlighting off (<LEADER>ho)
vim.keymap.set(
	"n",
	"<leader>ho",
	":nohlsearch<CR>",
	{ noremap = true, silent = true, desc = "turn off vim search highlights" }
)
